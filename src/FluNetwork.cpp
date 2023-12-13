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
#include <QEventLoop>
#include <QGuiApplication>

NetworkCallable::NetworkCallable(QObject *parent):QObject{parent}{

}

QString NetworkParams::method2String(){
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

int NetworkParams::getTimeout(){
    if(_timeout != -1){
        return _timeout;
    }
    return FluNetwork::getInstance()->timeout();
}

int NetworkParams::getRetry(){
    if(_retry != -1){
        return _retry;
    }
    return FluNetwork::getInstance()->retry();
}

bool NetworkParams::getOpenLog(){
    if(!_openLog.isNull()){
        return _openLog.toBool();
    }
    return FluNetwork::getInstance()->openLog();
}

DownloadParam::DownloadParam(QObject *parent)
    : QObject{parent}
{
}

DownloadParam::DownloadParam(QString destPath,bool append,QObject *parent)
    : QObject{parent}
{
    this->_destPath = destPath;
    this->_append = append;
}

NetworkParams::NetworkParams(QObject *parent)
    : QObject{parent}
{
}

NetworkParams::NetworkParams(QString url,Type type,Method method,QObject *parent)
    : QObject{parent}
{
    this->_method = method;
    this->_url = url;
    this->_type = type;
}

NetworkParams* NetworkParams::add(QString key,QVariant val){
    _paramMap.insert(key,val);
    return this;
}

NetworkParams* NetworkParams::addFile(QString key,QVariant val){
    _fileMap.insert(key,val);
    return this;
}

NetworkParams* NetworkParams::addHeader(QString key,QVariant val){
    _headerMap.insert(key,val);
    return this;
}

NetworkParams* NetworkParams::addQuery(QString key,QVariant val){
    _queryMap.insert(key,val);
    return this;
}

NetworkParams* NetworkParams::setBody(QString val){
    _body = val;
    return this;
}

NetworkParams* NetworkParams::setTimeout(int val){
    _timeout = val;
    return this;
}

NetworkParams* NetworkParams::setRetry(int val){
    _retry = val;
    return this;
}

NetworkParams* NetworkParams::setCacheMode(int val){
    _cacheMode = val;
    return this;
}

NetworkParams* NetworkParams::toDownload(QString destPath,bool append){
    _downloadParam = new DownloadParam(destPath,append,this);
    return this;
}

NetworkParams* NetworkParams::bind(QObject* target){
    _target = target;
    return this;
}

NetworkParams* NetworkParams::openLog(QVariant val){
    _openLog = val;
    return this;
}

QString NetworkParams::buildCacheKey(){
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

void NetworkParams::go(NetworkCallable* callable){
    QJSValueList data;
    data<<qjsEngine(FluNetwork::getInstance())->newQObject(this);
    FluNetwork::getInstance()->_interceptor.call(data);
    if(_downloadParam){
        FluNetwork::getInstance()->handleDownload(this,callable);
    }else{
        FluNetwork::getInstance()->handle(this,callable);
    }
}

void FluNetwork::handle(NetworkParams* params,NetworkCallable* c){
    QPointer<NetworkCallable> callable(c);
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
            QMetaObject::Connection conn_destoryed = {};
            QMetaObject::Connection conn_quit = {};
            if(params->_target){
                conn_destoryed =  connect(params->_target,&QObject::destroyed,&manager,abortCallable);
            }
            conn_quit = connect(qApp,&QGuiApplication::aboutToQuit,&manager, abortCallable);
            loop.exec();
            if(conn_destoryed){
                disconnect(conn_destoryed);
            }
            if(conn_quit){
                disconnect(conn_quit);
            }
            QString response;
            if(params->_method == NetworkParams::METHOD_HEAD){
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

void FluNetwork::handleDownload(NetworkParams* params,NetworkCallable* c){
    QPointer<NetworkCallable> callable(c);
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
        QMetaObject::Connection conn_destoryed = {};
        QMetaObject::Connection conn_quit = {};
        if(params->_target){
            conn_destoryed =  connect(params->_target,&QObject::destroyed,&manager,abortCallable);
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
        if(conn_destoryed){
            disconnect(conn_destoryed);
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

void FluNetwork::sendRequest(QNetworkAccessManager* manager,QNetworkRequest request,NetworkParams* params,QNetworkReply*& reply,bool isFirst,QPointer<NetworkCallable> callable){
    QByteArray verb = params->method2String().toUtf8();
    switch (params->_type) {
    case NetworkParams::TYPE_FORM:{
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
    case NetworkParams::TYPE_JSON:{
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
    case NetworkParams::TYPE_JSONARRAY:{
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
    case NetworkParams::TYPE_BODY:{
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

void FluNetwork::printRequestStartLog(QNetworkRequest request,NetworkParams* params){
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

void FluNetwork::printRequestEndLog(QNetworkRequest request,NetworkParams* params,QNetworkReply*& reply,const QString& response){
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

NetworkParams* FluNetwork::get(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_NONE,NetworkParams::METHOD_GET,this);
}

NetworkParams* FluNetwork::head(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_NONE,NetworkParams::METHOD_HEAD,this);
}

NetworkParams* FluNetwork::postBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_POST,this);
}

NetworkParams* FluNetwork::putBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_PUT,this);
}

NetworkParams* FluNetwork::patchBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_PATCH,this);
}

NetworkParams* FluNetwork::deleteBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_DELETE,this);
}

NetworkParams* FluNetwork::postForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_POST,this);
}

NetworkParams* FluNetwork::putForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_PUT,this);
}

NetworkParams* FluNetwork::patchForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_PATCH,this);
}

NetworkParams* FluNetwork::deleteForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_DELETE,this);
}

NetworkParams* FluNetwork::postJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_POST,this);
}

NetworkParams* FluNetwork::putJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_PUT,this);
}

NetworkParams* FluNetwork::patchJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_PATCH,this);
}

NetworkParams* FluNetwork::deleteJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_DELETE,this);
}

NetworkParams* FluNetwork::postJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_POST,this);
}

NetworkParams* FluNetwork::putJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_PUT,this);
}

NetworkParams* FluNetwork::patchJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_PATCH,this);
}

NetworkParams* FluNetwork::deleteJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_DELETE,this);
}

void FluNetwork::setInterceptor(QJSValue interceptor){
    this->_interceptor = interceptor;
}
