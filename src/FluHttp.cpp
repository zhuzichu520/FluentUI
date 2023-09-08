#include "FluHttp.h"

#include <QThreadPool>
#include <QEventLoop>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QHttpMultiPart>
#include <QGuiApplication>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QTextStream>
#include <QDir>
#include "Def.h"
#include "FluApp.h"
#include "FluTools.h"

HttpRequest::HttpRequest(QObject *parent)
    : QObject{parent}
{
}

QMap<QString, QVariant> HttpRequest::toMap(){
    QVariant _params;
    bool isPostString = method() == "postString";
    if(params().isNull()){
        if(isPostString){
            _params = "";
        }else{
            _params = QMap<QString,QVariant>();
        }
    }else{
        _params = params();
    }
    QVariant _headers;
    if(headers().isNull()){
        _headers = QMap<QString,QVariant>();
    }else{
        _params = params();
    }
    QMap<QString, QVariant> request = {
        {"url",url()},
        {"headers",_headers.toMap()},
        {"method",method()},
        {"downloadSavePath",downloadSavePath()}
    };
    if(isPostString){
        request.insert("params",_params.toString());
    }else{
        request.insert("params",_params.toMap());
    }
    return request;
}

QString HttpRequest::httpId(){
    return FluTools::getInstance()->sha256(QJsonDocument::fromVariant(QVariant(toMap())).toJson(QJsonDocument::Compact));
}

HttpCallable::HttpCallable(QObject *parent)
    : QObject{parent}
{
}

FluHttp::FluHttp(QObject *parent)
    : QObject{parent}
{
    retry(3);
    timeout(15000);
    cacheMode(FluHttpType::CacheMode::NoCache);
    cacheDir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation)+"/httpcache");
    breakPointDownload(false);
}

FluHttp::~FluHttp(){
    cancel();
}

void FluHttp::cancel(){
    foreach (QPointer<QNetworkReply> item, _cacheReply) {
        if(item){
            item->abort();
        }
    }
}

void FluHttp::post(HttpRequest* request,HttpCallable* callable){
    request->method("post");
    auto requestMap = request->toMap();
    auto httpId = request->httpId();
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
            onFinish(callable,request);
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
        }
        QNetworkAccessManager manager;
        manager.setTransferTimeout(timeout());
        for (int i = 0; i < retry(); ++i) {
            QUrl url(request->url());
            QNetworkRequest req(url);
            addHeaders(&req,data["headers"].toMap());
            QHttpMultiPart multiPart(QHttpMultiPart::FormDataType);
            for (const auto& each : data["params"].toMap().toStdMap())
            {
                const QString& key = each.first;
                const QString& value = each.second.toString();
                QString dispositionHeader = QString("form-data; name=\"%1\"").arg(key);
                QHttpPart part;
                part.setHeader(QNetworkRequest::ContentDispositionHeader, dispositionHeader);
                part.setBody(value.toUtf8());
                multiPart.append(part);
            }
            QEventLoop loop;
            QNetworkReply* reply = manager.post(req,&multiPart);
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
            connect(qApp,&QGuiApplication::aboutToQuit,&manager, [&loop](){loop.quit();});
            loop.exec();
            QString result = QString::fromUtf8(reply->readAll());
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(httpId,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        onCache(callable,readCache(httpId));
                    }
                    onError(callable,status,errorString,result);
                }
            }
        }
        onFinish(callable,request);
    });
}

void FluHttp::postString(HttpRequest* request,HttpCallable* callable){
    request->method("postString");
    auto requestMap = request->toMap();
    auto httpId = request->httpId();
    QString params = request->params().toString();
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
            onFinish(callable,request);
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
        }
        QNetworkAccessManager manager;
        manager.setTransferTimeout(timeout());
        for (int i = 0; i < retry(); ++i) {
            QUrl url(request->url());
            QNetworkRequest req(url);
            addHeaders(&req,data["headers"].toMap());
            QString contentType = QString("text/plain;charset=utf-8");
            req.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
            QEventLoop loop;
            QNetworkReply* reply = manager.post(req,params.toUtf8());
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
            connect(qApp,&QGuiApplication::aboutToQuit,&manager, [&loop](){loop.quit();});
            loop.exec();
            QString result = QString::fromUtf8(reply->readAll());
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(httpId,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        onCache(callable,readCache(httpId));
                    }
                    onError(callable,status,errorString,result);
                }
            }
        }
        onFinish(callable,request);
    });
}

void FluHttp::postJson(HttpRequest* request,HttpCallable* callable){
    request->method("postJson");
    auto requestMap = request->toMap();
    auto httpId = request->httpId();
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
            onFinish(callable,request);
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
        }
        QNetworkAccessManager manager;
        manager.setTransferTimeout(timeout());
        for (int i = 0; i < retry(); ++i) {
            QUrl url(request->url());
            QNetworkRequest req(url);
            addHeaders(&req,data["headers"].toMap());
            QString contentType = QString("application/json;charset=utf-8");
            req.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
            QEventLoop loop;
            QNetworkReply* reply = manager.post(req,QJsonDocument::fromVariant(data["params"]).toJson());
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
            connect(qApp,&QGuiApplication::aboutToQuit,&manager, [&loop](){loop.quit();});
            loop.exec();
            QString result = QString::fromUtf8(reply->readAll());
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(httpId,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        onCache(callable,readCache(httpId));
                    }
                    onError(callable,status,errorString,result);
                }
            }
        }
        onFinish(callable,request);
    });
}

void FluHttp::get(HttpRequest* request,HttpCallable* callable){
    request->method("get");
    auto requestMap = request->toMap();
    auto httpId = request->httpId();
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
        }
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            onCache(callable,readCache(httpId));
            onFinish(callable,request);
            return;
        }
        QNetworkAccessManager manager;
        manager.setTransferTimeout(timeout());
        for (int i = 0; i < retry(); ++i) {
            QUrl url(request->url());
            addQueryParam(&url,data["params"].toMap());
            QNetworkRequest req(url);
            addHeaders(&req,data["headers"].toMap());
            QEventLoop loop;
            QNetworkReply* reply = manager.get(req);
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
            connect(qApp,&QGuiApplication::aboutToQuit,&manager, [&loop](){loop.quit();});
            loop.exec();
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            QString result = QString::fromUtf8(reply->readAll());
            if (isSuccess) {
                handleCache(httpId,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        onCache(callable,readCache(httpId));
                    }
                    onError(callable,status,errorString,result);
                }
            }
            reply->deleteLater();
            reply = nullptr;
        }
        onFinish(callable,request);
    });
}

void FluHttp::download(HttpRequest* request,HttpCallable* callable){
    request->method("download");
    auto requestMap = request->toMap();
    auto httpId = request->httpId();
    auto savePath = request->downloadSavePath();
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
        QNetworkAccessManager manager;
        QUrl url(request->url());
        addQueryParam(&url,data["params"].toMap());
        QNetworkRequest req(url);
        addHeaders(&req,data["headers"].toMap());
        QSharedPointer<QFile> file(new QFile(savePath));
        QDir dir = QFileInfo(savePath).path();
        if (!dir.exists(dir.path())){
            dir.mkpath(dir.path());
        }
        QEventLoop loop;
        connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
        connect(qApp,&QGuiApplication::aboutToQuit,&manager, [&loop](){loop.quit();});
        qint64 seek = 0;
        auto filePath = getCacheFilePath(httpId);
        QSharedPointer<QFile> fileCache(new QFile(filePath));
        if(fileCache->exists() && file->exists() && _breakPointDownload){
            QJsonObject cacheInfo = QJsonDocument::fromJson(readCache(httpId).toUtf8()).object();
            qint64 fileSize = cacheInfo.value("fileSize").toDouble();
            qint64 contentLength = cacheInfo.value("contentLength").toDouble();
            if(fileSize == contentLength && file->size() == contentLength){
                onDownloadProgress(callable,fileSize,contentLength);
                onSuccess(callable,savePath);
                onFinish(callable,request);
                return;
            }
            if(fileSize==file->size()){
                req.setRawHeader("Range", QString("bytes=%1-").arg(fileSize).toUtf8());
                seek = fileSize;
                file->open(QIODevice::WriteOnly|QIODevice::Append);
            }else{
                file->open(QIODevice::WriteOnly|QIODevice::Truncate);
            }
        }else{
            file->open(QIODevice::WriteOnly|QIODevice::Truncate);
        }
        QNetworkReply* reply =  manager.get(req);
        _cacheReply.append(reply);
        if (!fileCache->open(QIODevice::WriteOnly|QIODevice::Truncate))
        {
            qDebug()<<"FileCache Error";
        }
        connect(reply,&QNetworkReply::readyRead,reply,[reply,file,fileCache,requestMap,callable,seek,this]{
            if (!reply || !file || reply->error() != QNetworkReply::NoError)
            {
                return;
            }
            QMap<QString, QVariant> downMap = requestMap;
            qint64 contentLength = reply->header(QNetworkRequest::ContentLengthHeader).toLongLong()+seek;
            downMap.insert("contentLength",contentLength);
            QString eTag = reply->header(QNetworkRequest::ETagHeader).toString();
            downMap.insert("eTag",eTag);
            file->write(reply->readAll());
            file->flush();
            downMap.insert("fileSize",file->size());
            fileCache->resize(0);
            fileCache->write(FluTools::getInstance()->toBase64(QJsonDocument::fromVariant(QVariant(downMap)).toJson()).toUtf8());
            fileCache->flush();
            onDownloadProgress(callable,file->size(),contentLength);
        });
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            onSuccess(callable,savePath);
        }else{
            onError(callable,reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString(),"");
        }
        reply->deleteLater();
        reply = nullptr;
        onFinish(callable,request);
    });
}

void FluHttp::upload(HttpRequest* request,HttpCallable* callable){
    request->method("upload");
    auto requestMap = request->toMap();
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
        QNetworkAccessManager manager;
        manager.setTransferTimeout(timeout());
        QUrl url(request->url());
        QNetworkRequest req(url);
        addHeaders(&req,data["headers"].toMap());
        QHttpMultiPart multiPart(QHttpMultiPart::FormDataType);
        qDebug()<<data["params"].toMap();
        for (const auto& each : data["params"].toMap().toStdMap())
        {
            const QString& key = each.first;
            const QString& filePath = each.second.toString();
            QFile *file = new QFile(filePath);
            file->open(QIODevice::ReadOnly);
            file->setParent(&multiPart);
            QString dispositionHeader = QString("form-data; name=\"%1\"; filename=\"%2\"").arg(key,filePath);
            QHttpPart part;
            part.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("application/octet-stream"));
            part.setHeader(QNetworkRequest::ContentDispositionHeader, dispositionHeader);
            part.setBodyDevice(file);
            multiPart.append(part);
        }
        QEventLoop loop;
        QNetworkReply* reply = manager.post(req,&multiPart);
        _cacheReply.append(reply);
        connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){loop.quit();});
        connect(qApp,&QGuiApplication::aboutToQuit,&manager, [&loop](){loop.quit();});
        connect(reply,&QNetworkReply::uploadProgress,reply,[=](qint64 bytesSent, qint64 bytesTotal){
            onUploadProgress(callable,bytesSent,bytesTotal);
        });
        loop.exec();
        QString result = QString::fromUtf8(reply->readAll());
        int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        QString errorString = reply->errorString();
        bool isSuccess = reply->error() == QNetworkReply::NoError;
        reply->deleteLater();
        reply = nullptr;
        if (isSuccess) {
            onSuccess(callable,result);
        }else{
            onError(callable,status,errorString,result);
        }
        onFinish(callable,request);
    });
}

QVariant FluHttp::invokeIntercept(QMap<QString, QVariant> request){
    if(!FluApp::getInstance()->httpInterceptor()){
        return request;
    }
    QVariant target;
    QMetaObject::invokeMethod(FluApp::getInstance()->httpInterceptor(), "onIntercept",Q_RETURN_ARG(QVariant,target),Q_ARG(QVariant, request));
    return target;
}

void FluHttp::addQueryParam(QUrl* url,const QMap<QString, QVariant>& params){
    QMapIterator<QString, QVariant> iter(params);
    QUrlQuery urlQuery(*url);
    while (iter.hasNext())
    {
        iter.next();
        urlQuery.addQueryItem(iter.key(), iter.value().toString());
    }
    url->setQuery(urlQuery);
}

void FluHttp::addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& headers){
    QMapIterator<QString, QVariant> iter(headers);
    while (iter.hasNext())
    {
        iter.next();
        request->setRawHeader(iter.key().toUtf8(), iter.value().toString().toUtf8());
    }
}

QString FluHttp::readCache(const QString& httpId){
    auto filePath = getCacheFilePath(httpId);
    QString result;
    QFile file(filePath);
    if(!file.exists()){
        return result;
    }
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        result = FluTools::getInstance()->fromBase64(stream.readAll().toUtf8());
    }
    return result;
}

bool FluHttp::cacheExists(const QString& httpId){
    return QFile(getCacheFilePath(httpId)).exists();
}

QString FluHttp::getCacheFilePath(const QString& httpId){
    QDir dir = _cacheDir;
    if (!dir.exists(_cacheDir)){
        dir.mkpath(_cacheDir);
    }
    auto filePath = _cacheDir+"/"+httpId;
    return filePath;
}

void FluHttp::handleCache(const QString& httpId,const QString& result){
    if(_cacheMode==FluHttpType::CacheMode::NoCache){
        return;
    }
    auto filePath = getCacheFilePath(httpId);
    QSharedPointer<QFile> file(new QFile(filePath));
    QIODevice::OpenMode mode = QIODevice::WriteOnly|QIODevice::Truncate;
    if (!file->open(mode))
    {
        return;
    }
    file->write(FluTools::getInstance()->toBase64(result).toUtf8());
}

qreal FluHttp::getBreakPointProgress(HttpRequest* request){
    request->method("download");
    auto httpId = request->httpId();
    QSharedPointer<QFile> file(new QFile(request->downloadSavePath()));
    auto filePath = getCacheFilePath(httpId);
    QSharedPointer<QFile> fileCache(new QFile(filePath));
    if(fileCache->exists() && file->exists() && _breakPointDownload){
        QJsonObject cacheInfo = QJsonDocument::fromJson(readCache(httpId).toUtf8()).object();
        double fileSize = cacheInfo.value("fileSize").toDouble();
        double contentLength = cacheInfo.value("contentLength").toDouble();
        if(fileSize == contentLength && file->size() == contentLength){
            return 1;
        }
        if(fileSize==file->size()){
            return fileSize/contentLength;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

HttpRequest* FluHttp::newRequest(QString url){
    HttpRequest* request = new HttpRequest(this);
    request->url(url);
    return request;
}

void FluHttp::onStart(QPointer<HttpCallable> callable){
    if(callable){
        Q_EMIT callable->start();
    }
}

void FluHttp::onFinish(QPointer<HttpCallable> callable,HttpRequest* request){
    if(callable){
        Q_EMIT callable->finish();
    }
    if(request->parent()->inherits("FluHttp")){
        request->deleteLater();
    }
}

void FluHttp::onError(QPointer<HttpCallable> callable,int status,QString errorString,QString result){
    if(callable){
        Q_EMIT callable->error(status,errorString,result);
    }
}

void FluHttp::onSuccess(QPointer<HttpCallable> callable,QString result){
    if(callable){
        Q_EMIT callable->success(result);
    }
}

void FluHttp::onCache(QPointer<HttpCallable> callable,QString result){
    if(callable){
        Q_EMIT callable->cache(result);
    }
}

void FluHttp::onDownloadProgress(QPointer<HttpCallable> callable,qint64 recv,qint64 total){
    if(callable){
        Q_EMIT callable->downloadProgress(recv,total);
    }
}

void FluHttp::onUploadProgress(QPointer<HttpCallable> callable,qint64 sent,qint64 total){
    if(callable){
        Q_EMIT callable->uploadProgress(sent,total);
    }
}
