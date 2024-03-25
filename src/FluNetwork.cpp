#include "FluNetwork.h"

#include <QUrlQuery>
#include <QBuffer>
#include <QHttpMultiPart>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QJsonObject>
#include <QNetworkDiskCache>
#include <QQmlEngine>
#include <QQmlContext>
#include <QJSEngine>
#include <QJsonArray>
#include <QStandardPaths>
#include <QThreadPool>
#include <QDir>
#include <QCryptographicHash>
#include <QEventLoop>
#include <QGuiApplication>

FluNetworkCallable::FluNetworkCallable(QObject *parent):QObject{parent}{

}

QString FluNetworkParams::method2String(){
    switch (_method) {
    case METHOD_GET:
        return "GET";
    case METHOD_HEAD:
        return "HEAD";
    case METHOD_POST:
        return "POST";
    case METHOD_PUT:
        return "PUT";
    case METHOD_PATCH:
        return "PATCH";
    case METHOD_DELETE:
        return "DELETE";
    default:
        return "";
    }
}

int FluNetworkParams::getTimeout(){
    if(_timeout != -1){
        return _timeout;
    }
    return FluNetwork::getInstance()->timeout();
}

int FluNetworkParams::getRetry(){
    if(_retry != -1){
        return _retry;
    }
    return FluNetwork::getInstance()->retry();
}

bool FluNetworkParams::getOpenLog(){
    if(!_openLog.isNull()){
        return _openLog.toBool();
    }
    return FluNetwork::getInstance()->openLog();
}

FluDownloadParam::FluDownloadParam(QObject *parent)
    : QObject{parent}
{
}

FluDownloadParam::FluDownloadParam(QString destPath,bool append,QObject *parent)
    : QObject{parent}
{
    this->_destPath = destPath;
    this->_append = append;
}

FluNetworkParams::FluNetworkParams(QObject *parent)
    : QObject{parent}
{
}

FluNetworkParams::FluNetworkParams(QString url,Type type,Method method,QObject *parent)
    : QObject{parent}
{
    this->_method = method;
    this->_url = url;
    this->_type = type;
}

FluNetworkParams* FluNetworkParams::add(QString key,QVariant val){
    _paramMap.insert(key,val);
    return this;
}

FluNetworkParams* FluNetworkParams::addFile(QString key,QVariant val){
    _fileMap.insert(key,val);
    return this;
}

FluNetworkParams* FluNetworkParams::addHeader(QString key,QVariant val){
    _headerMap.insert(key,val);
    return this;
}

FluNetworkParams* FluNetworkParams::addQuery(QString key,QVariant val){
    _queryMap.insert(key,val);
    return this;
}

FluNetworkParams* FluNetworkParams::setBody(QString val){
    _body = val;
    return this;
}

FluNetworkParams* FluNetworkParams::setTimeout(int val){
    _timeout = val;
    return this;
}

FluNetworkParams* FluNetworkParams::setRetry(int val){
    _retry = val;
    return this;
}

FluNetworkParams* FluNetworkParams::setCacheMode(int val){
    _cacheMode = val;
    return this;
}

FluNetworkParams* FluNetworkParams::toDownload(QString destPath,bool append){
    _downloadParam = new FluDownloadParam(destPath,append,this);
    return this;
}

FluNetworkParams* FluNetworkParams::bind(QObject* target){
    _target = target;
    return this;
}

FluNetworkParams* FluNetworkParams::openLog(QVariant val){
    _openLog = val;
    return this;
}

QString FluNetworkParams::buildCacheKey(){
    QJsonObject obj;
    obj.insert("url",_url);
    obj.insert("method",method2String());
    obj.insert("body",_body);
    obj.insert("query",QJsonDocument::fromVariant(_queryMap).object());
    obj.insert("param",QJsonDocument::fromVariant(_paramMap).object());
    obj.insert("header",QJsonDocument::fromVariant(_headerMap).object());
    obj.insert("file",QJsonDocument::fromVariant(_fileMap).object());
    if(_downloadParam){
        QJsonObject downObj;
        downObj.insert("destPath",_downloadParam->_destPath);
        downObj.insert("append",_downloadParam->_append);
        obj.insert("download",downObj);
    }
    QByteArray data = QJsonDocument(obj).toJson(QJsonDocument::Compact);
    return QCryptographicHash::hash(data, QCryptographicHash::Sha256).toHex();
}

void FluNetworkParams::go(FluNetworkCallable* callable){
    QJSValueList data;
    data<<qjsEngine(callable)->newQObject(this);
    FluNetwork::getInstance()->_interceptor.call(data);
    if(_downloadParam){
        FluNetwork::getInstance()->handleDownload(this,callable);
    }else{
        FluNetwork::getInstance()->handle(this,callable);
    }
}

void FluNetwork::handle(FluNetworkParams* params,FluNetworkCallable* c){
    QPointer<FluNetworkCallable> callable(c);
    QThreadPool::globalInstance()->start([=](){
        if(!callable.isNull()){
            callable->start();
        }
        QString cacheKey = params->buildCacheKey();
        if(params->_cacheMode == FluNetworkType::CacheMode::FirstCacheThenRequest && cacheExists(cacheKey)){
            if(!callable.isNull()){
                callable->cache(readCache(cacheKey));
            }
        }
        if(params->_cacheMode == FluNetworkType::CacheMode::IfNoneCacheRequest && cacheExists(cacheKey)){
            if(!callable.isNull()){
                callable->cache(readCache(cacheKey));
                callable->finish();
                params->deleteLater();
            }
            return;
        }
        QNetworkAccessManager manager;
        manager.setTransferTimeout(params->getTimeout());
        QEventLoop loop;
        connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
        for (int i = 0; i < params->getRetry(); ++i) {
            QUrl url(params->_url);
            addQueryParam(&url,params->_queryMap);
            QNetworkRequest request(url);
            addHeaders(&request,params->_headerMap);
            QNetworkReply* reply;
            sendRequest(&manager,request,params,reply,i==0,callable);
            if(!QPointer<QGuiApplication>(qApp)){
                reply->deleteLater();
                reply = nullptr;
                return;
            }
            auto abortCallable = [&loop,reply,&i,params]{
                if(reply){
                    i = params->getRetry();
                    reply->abort();
                }
            };
            QMetaObject::Connection conn_destroyed = {};
            QMetaObject::Connection conn_quit = {};
            if(params->_target){
                conn_destroyed =  connect(params->_target,&QObject::destroyed,&manager,abortCallable);
            }
            conn_quit = connect(qApp,&QGuiApplication::aboutToQuit,&manager, abortCallable);
            loop.exec();
            if(conn_destroyed){
                disconnect(conn_destroyed);
            }
            if(conn_quit){
                disconnect(conn_quit);
            }
            QString response;
            if(params->_method == FluNetworkParams::METHOD_HEAD){
                response = headerList2String(reply->rawHeaderPairs());
            }else{
                if(reply->isOpen()){
                    response = QString::fromUtf8(reply->readAll());
                }
            }
            int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            if(httpStatus == 200){
                if(!callable.isNull()){
                    if(params->_cacheMode != FluNetworkType::CacheMode::NoCache){
                        saveResponse(cacheKey,response);
                    }
                    callable->success(response);
                }
                printRequestEndLog(request,params,reply,response);
                break;
            }else{
                if(i == params->getRetry()-1){
                    if(!callable.isNull()){
                        if(params->_cacheMode == FluNetworkType::CacheMode::RequestFailedReadCache && cacheExists(cacheKey)){
                            if(!callable.isNull()){
                                callable->cache(readCache(cacheKey));
                            }
                        }
                        callable->error(httpStatus,reply->errorString(),response);
                    }
                    printRequestEndLog(request,params,reply,response);
                }
            }
            reply->deleteLater();
        }
        params->deleteLater();
        if(!callable.isNull()){
            callable->finish();
        }
    });
}

void FluNetwork::handleDownload(FluNetworkParams* params,FluNetworkCallable* c){
    QPointer<FluNetworkCallable> callable(c);
    QThreadPool::globalInstance()->start([=](){
        if(!callable.isNull()){
            callable->start();
        }
        QString cacheKey = params->buildCacheKey();
        QUrl url(params->_url);
        QNetworkAccessManager manager;
        manager.setTransferTimeout(params->getTimeout());
        addQueryParam(&url,params->_queryMap);
        QNetworkRequest request(url);
        addHeaders(&request,params->_headerMap);
        QString cachePath = getCacheFilePath(cacheKey);
        QString destPath = params->_downloadParam->_destPath;
        QFile* destFile = new QFile(destPath);
        QFile* cacheFile = new QFile(cachePath);
        bool isOpen = false;
        qint64 seek = 0;
        if(cacheFile->exists() && destFile->exists() && params->_downloadParam->_append){
            QJsonObject cacheInfo = QJsonDocument::fromJson(readCache(cacheKey).toUtf8()).object();
            qint64 fileSize = cacheInfo.value("fileSize").toDouble();
            qint64 contentLength = cacheInfo.value("contentLength").toDouble();
            if(fileSize == contentLength && destFile->size() == contentLength){
                if(!callable.isNull()){
                    callable->downloadProgress(fileSize,contentLength);
                    callable->success(destPath);
                    callable->finish();
                }
                return;
            }
            if(fileSize==destFile->size()){
                request.setRawHeader("Range", QString("bytes=%1-").arg(fileSize).toUtf8());
                seek = fileSize;
                isOpen = destFile->open(QIODevice::WriteOnly|QIODevice::Append);
            }else{
                isOpen = destFile->open(QIODevice::WriteOnly|QIODevice::Truncate);
            }
        }else{
            isOpen = destFile->open(QIODevice::WriteOnly|QIODevice::Truncate);
        }
        if(!isOpen){
            if(!callable.isNull()){
                callable->error(-1,"device not open","");
                callable->finish();
            }
            return;
        }
        if(params->_downloadParam->_append){
            if (!cacheFile->open(QIODevice::WriteOnly|QIODevice::Truncate))
            {
                if(!callable.isNull()){
                    callable->error(-1,"cache file device not open","");
                    callable->finish();
                }
                return;
            }
        }
        QEventLoop loop;
        QNetworkReply *reply = manager.get(request);
        destFile->setParent(reply);
        cacheFile->setParent(reply);
        auto abortCallable = [&loop,reply,params]{
            if(reply){
                reply->abort();
            }
        };
        connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
        connect(qApp,&QGuiApplication::aboutToQuit,&manager, [&loop,reply](){reply->abort(),loop.quit();});
        QMetaObject::Connection conn_destroyed = {};
        QMetaObject::Connection conn_quit = {};
        if(params->_target){
            conn_destroyed =  connect(params->_target,&QObject::destroyed,&manager,abortCallable);
        }
        conn_quit = connect(qApp,&QGuiApplication::aboutToQuit,&manager, abortCallable);
        connect(reply,&QNetworkReply::readyRead,reply,[reply,seek,destFile,cacheFile,callable]{
            if (!reply || !destFile || reply->error() != QNetworkReply::NoError)
            {
                return;
            }
            QMap<QString, QVariant> downInfo;
            qint64 contentLength = reply->header(QNetworkRequest::ContentLengthHeader).toLongLong()+seek;
            downInfo.insert("contentLength",contentLength);
            QString eTag = reply->header(QNetworkRequest::ETagHeader).toString();
            downInfo.insert("eTag",eTag);
            destFile->write(reply->readAll());
            destFile->flush();
            downInfo.insert("fileSize",destFile->size());
            if(cacheFile->isOpen()){
                cacheFile->resize(0);
                cacheFile->write(QJsonDocument::fromVariant(QVariant(downInfo)).toJson().toBase64());
                cacheFile->flush();
            }
            if(!callable.isNull()){
                callable->downloadProgress(destFile->size(),contentLength);
            }
        });
        loop.exec();
        int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if(httpStatus == 200){
            if(!callable.isNull()){
                callable->success(destPath);
            }
            printRequestEndLog(request,params,reply,destPath);
        }else{
            if(!callable.isNull()){
                callable->error(httpStatus,reply->errorString(),destPath);
            }
            printRequestEndLog(request,params,reply,destPath);
        }
        if(conn_destroyed){
            disconnect(conn_destroyed);
        }
        if(conn_quit){
            disconnect(conn_quit);
        }
        params->deleteLater();
        reply->deleteLater();
        if(!callable.isNull()){
            callable->finish();
        }
    });
}

QString FluNetwork::readCache(const QString& key){
    auto filePath = getCacheFilePath(key);
    QString result;
    QFile file(filePath);
    if(!file.exists()){
        return result;
    }
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        result = QString(QByteArray::fromBase64(stream.readAll().toUtf8()));
    }
    return result;
}

bool FluNetwork::cacheExists(const QString& key){
    return QFile(getCacheFilePath(key)).exists();
}

QString FluNetwork::getCacheFilePath(const QString& key){
    QDir cacheDir(_cacheDir);
    if(!cacheDir.exists()){
        cacheDir.mkpath(_cacheDir);
    }
    return cacheDir.absoluteFilePath(key);
}

QString FluNetwork::headerList2String(const QList<QNetworkReply::RawHeaderPair>& data){
    QJsonObject object;
    for (auto it = data.constBegin(); it != data.constEnd(); ++it) {
        object.insert(QString(it->first),QString(it->second));
    }
    return QJsonDocument(object).toJson(QJsonDocument::Compact);
}

QString FluNetwork::map2String(const QMap<QString, QVariant>& map){
    QStringList parameters;
    for (auto it = map.constBegin(); it != map.constEnd(); ++it) {
        parameters << QString("%1=%2").arg(it.key(), it.value().toString());
    }
    return parameters.join(" ");
}

void FluNetwork::sendRequest(QNetworkAccessManager* manager,QNetworkRequest request,FluNetworkParams* params,QNetworkReply*& reply,bool isFirst,QPointer<FluNetworkCallable> callable){
    QByteArray verb = params->method2String().toUtf8();
    switch (params->_type) {
    case FluNetworkParams::TYPE_FORM:{
        bool isFormData = !params->_fileMap.isEmpty();
        if(isFormData){
            QHttpMultiPart *multiPart = new QHttpMultiPart();
            multiPart->setContentType(QHttpMultiPart::FormDataType);
            for (const auto& each : params->_paramMap.toStdMap())
            {
                QHttpPart part;
                part.setHeader(QNetworkRequest::ContentDispositionHeader, QString("form-data; name=\"%1\"").arg(each.first));
                part.setBody(each.second.toByteArray());
                multiPart->append(part);
            }
            for (const auto& each : params->_fileMap.toStdMap())
            {
                QString filePath = each.second.toString();
                QString name = each.first;
                QFile *file = new QFile(filePath);
                QString fileName = QFileInfo(filePath).fileName();
                file->open(QIODevice::ReadOnly);
                file->setParent(multiPart);
                QHttpPart part;
                part.setHeader(QNetworkRequest::ContentDispositionHeader, QString("form-data; name=\"%1\"; filename=\"%2\"").arg(name,fileName));
                part.setBodyDevice(file);
                multiPart->append(part);
            }
            reply = manager->sendCustomRequest(request,verb,multiPart);
            multiPart->setParent(reply);
            connect(reply,&QNetworkReply::uploadProgress,reply,[callable](qint64 bytesSent, qint64 bytesTotal){
                if(!callable.isNull() && bytesSent!=0 && bytesTotal!=0){
                    Q_EMIT callable->uploadProgress(bytesSent,bytesTotal);
                }
            });
        }else{
            request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/x-www-form-urlencoded"));
            QString value;
            for (const auto& each : params->_paramMap.toStdMap())
            {
                value += QString("%1=%2").arg(each.first,each.second.toString());
                value += "&";
            }
            if(!params->_paramMap.isEmpty()){
                value.chop(1);
            }
            QByteArray data = value.toUtf8();
            reply = manager->sendCustomRequest(request,verb,data);
        }
        break;
    }
    case FluNetworkParams::TYPE_JSON:{
        request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json;charset=utf-8"));
        QJsonObject json;
        for (const auto& each : params->_paramMap.toStdMap())
        {
            json.insert(each.first,each.second.toJsonValue());
        }
        QByteArray data = QJsonDocument(json).toJson(QJsonDocument::Compact);
        reply = manager->sendCustomRequest(request,verb,data);
        break;
    }
    case FluNetworkParams::TYPE_JSONARRAY:{
        request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json;charset=utf-8"));
        QJsonArray jsonArray;
        for (const auto& each : params->_paramMap.toStdMap())
        {
            QJsonObject json;
            json.insert(each.first,each.second.toJsonValue());
            jsonArray.append(json);
        }
        QByteArray data = QJsonDocument(jsonArray).toJson(QJsonDocument::Compact);
        reply = manager->sendCustomRequest(request,params->method2String().toUtf8(),data);
        break;
    }
    case FluNetworkParams::TYPE_BODY:{
        request.setHeader(QNetworkRequest::ContentTypeHeader, QString("text/plain;charset=utf-8"));
        QByteArray data = params->_body.toUtf8();
        reply = manager->sendCustomRequest(request,verb,data);
        break;
    }
    default:
        reply = manager->sendCustomRequest(request,verb);
        break;
    }
    if(isFirst){
        printRequestStartLog(request,params);
    }
}

void FluNetwork::printRequestStartLog(QNetworkRequest request,FluNetworkParams* params){
    if(!params->getOpenLog()){
        return;
    }
    qDebug()<<"<------"<<qUtf8Printable(request.header(QNetworkRequest::UserAgentHeader).toString())<<"Request Start ------>";
    qDebug()<<qUtf8Printable(QString::fromStdString("<%1>").arg(params->method2String()))<<qUtf8Printable(params->_url);
    auto contentType = request.header(QNetworkRequest::ContentTypeHeader).toString();
    if(!contentType.isEmpty()){
        qDebug()<<qUtf8Printable(QString::fromStdString("<Header> %1=%2").arg("Content-Type",contentType));
    }
    QList<QByteArray> headers = request.rawHeaderList();
    for(const QByteArray& header:headers){
        qDebug()<<qUtf8Printable(QString::fromStdString("<Header> %1=%2").arg(header,request.rawHeader(header)));
    }
    if(!params->_queryMap.isEmpty()){
        qDebug()<<"<Query>"<<qUtf8Printable(map2String(params->_queryMap));
    }
    if(!params->_paramMap.isEmpty()){
        qDebug()<<"<Param>"<<qUtf8Printable(map2String(params->_paramMap));
    }
    if(!params->_fileMap.isEmpty()){
        qDebug()<<"<File>"<<qUtf8Printable(map2String(params->_fileMap));
    }
    if(!params->_body.isEmpty()){
        qDebug()<<"<Body>"<<qUtf8Printable(params->_body);
    }
}

void FluNetwork::printRequestEndLog(QNetworkRequest request,FluNetworkParams* params,QNetworkReply*& reply,const QString& response){
    if(!params->getOpenLog()){
        return;
    }
    qDebug()<<"<------"<<qUtf8Printable(request.header(QNetworkRequest::UserAgentHeader).toString())<<"Request End ------>";
    qDebug()<<qUtf8Printable(QString::fromStdString("<%1>").arg(params->method2String()))<<qUtf8Printable(params->_url);
    qDebug()<<"<Result>"<<qUtf8Printable(response);
}

void FluNetwork::saveResponse(QString key,QString response){
    QSharedPointer<QFile> file(new QFile(getCacheFilePath(key)));
    QIODevice::OpenMode mode = QIODevice::WriteOnly|QIODevice::Truncate;
    if (!file->open(mode))
    {
        return;
    }
    file->write(response.toUtf8().toBase64());
}

void FluNetwork::addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& headers){
    request->setHeader(QNetworkRequest::UserAgentHeader,QString::fromStdString("Mozilla/5.0 %1/%2").arg(QGuiApplication::applicationName(),QGuiApplication::applicationVersion()));
    QMapIterator<QString, QVariant> iter(headers);
    while (iter.hasNext())
    {
        iter.next();
        request->setRawHeader(iter.key().toUtf8(), iter.value().toString().toUtf8());
    }
}

void FluNetwork::addQueryParam(QUrl* url,const QMap<QString, QVariant>& params){
    QMapIterator<QString, QVariant> iter(params);
    QUrlQuery urlQuery(*url);
    while (iter.hasNext())
    {
        iter.next();
        urlQuery.addQueryItem(iter.key(), iter.value().toString());
    }
    url->setQuery(urlQuery);
}

FluNetwork::FluNetwork(QObject *parent): QObject{parent}
{
    timeout(5000);
    retry(3);
    openLog(false);
    cacheDir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation).append(QDir::separator()).append("network"));
}

FluNetworkParams* FluNetwork::get(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_NONE,FluNetworkParams::METHOD_GET,this);
}

FluNetworkParams* FluNetwork::head(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_NONE,FluNetworkParams::METHOD_HEAD,this);
}

FluNetworkParams* FluNetwork::postBody(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_BODY,FluNetworkParams::METHOD_POST,this);
}

FluNetworkParams* FluNetwork::putBody(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_BODY,FluNetworkParams::METHOD_PUT,this);
}

FluNetworkParams* FluNetwork::patchBody(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_BODY,FluNetworkParams::METHOD_PATCH,this);
}

FluNetworkParams* FluNetwork::deleteBody(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_BODY,FluNetworkParams::METHOD_DELETE,this);
}

FluNetworkParams* FluNetwork::postForm(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_FORM,FluNetworkParams::METHOD_POST,this);
}

FluNetworkParams* FluNetwork::putForm(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_FORM,FluNetworkParams::METHOD_PUT,this);
}

FluNetworkParams* FluNetwork::patchForm(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_FORM,FluNetworkParams::METHOD_PATCH,this);
}

FluNetworkParams* FluNetwork::deleteForm(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_FORM,FluNetworkParams::METHOD_DELETE,this);
}

FluNetworkParams* FluNetwork::postJson(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSON,FluNetworkParams::METHOD_POST,this);
}

FluNetworkParams* FluNetwork::putJson(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSON,FluNetworkParams::METHOD_PUT,this);
}

FluNetworkParams* FluNetwork::patchJson(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSON,FluNetworkParams::METHOD_PATCH,this);
}

FluNetworkParams* FluNetwork::deleteJson(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSON,FluNetworkParams::METHOD_DELETE,this);
}

FluNetworkParams* FluNetwork::postJsonArray(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSONARRAY,FluNetworkParams::METHOD_POST,this);
}

FluNetworkParams* FluNetwork::putJsonArray(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSONARRAY,FluNetworkParams::METHOD_PUT,this);
}

FluNetworkParams* FluNetwork::patchJsonArray(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSONARRAY,FluNetworkParams::METHOD_PATCH,this);
}

FluNetworkParams* FluNetwork::deleteJsonArray(const QString& url){
    return new FluNetworkParams(url,FluNetworkParams::TYPE_JSONARRAY,FluNetworkParams::METHOD_DELETE,this);
}

void FluNetwork::setInterceptor(QJSValue interceptor){
    this->_interceptor = interceptor;
}
