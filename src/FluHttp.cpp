#include "FluHttp.h"

#include <QThreadPool>
#include <QEventLoop>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QHttpMultiPart>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QTextStream>
#include <QDir>
#include "Def.h"
#include "FluApp.h"
#include "FluTools.h"

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

void FluHttp::post(QString url,HttpCallable* callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    QThreadPool::globalInstance()->start([=](){
        auto requestMap = toRequest(url,params,headers,"post");
        auto httpId = toHttpId(requestMap);
        QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
            Q_EMIT callable->finish();
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
        }
        for (int i = 0; i < retry(); ++i) {
            QNetworkAccessManager manager;
            manager.setTransferTimeout(timeout());
            QUrl _url(url);
            QNetworkRequest request(_url);
            addHeaders(&request,data["headers"].toMap());
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
            QNetworkReply* reply = manager.post(request,&multiPart);
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){
                loop.quit();
            });
            loop.exec();
            QString result = QString::fromUtf8(reply->readAll());
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(httpId,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        Q_EMIT callable->cache(readCache(httpId));
                    }
                    Q_EMIT callable->error(status,errorString,result);
                }
            }
        }
        Q_EMIT callable->finish();
    });
}

void FluHttp::postString(QString url,HttpCallable* callable,QString params,QMap<QString, QVariant> headers){
    QThreadPool::globalInstance()->start([=](){
        auto requestMap = toRequest(url,params,headers,"postString");
        auto httpId = toHttpId(requestMap);
        QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
            Q_EMIT callable->finish();
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
        }
        for (int i = 0; i < retry(); ++i) {
            QNetworkAccessManager manager;
            manager.setTransferTimeout(timeout());
            QUrl _url(url);
            QNetworkRequest request(_url);
            addHeaders(&request,data["headers"].toMap());
            QString contentType = QString("text/plain;charset=utf-8");
            request.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
            QEventLoop loop;
            QNetworkReply* reply = manager.post(request,params.toUtf8());
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){
                loop.quit();
            });
            loop.exec();
            QString result = QString::fromUtf8(reply->readAll());
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(httpId,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        Q_EMIT callable->cache(readCache(httpId));
                    }
                    Q_EMIT callable->error(status,errorString,result);
                }
            }
        }
        Q_EMIT callable->finish();
    });
}

void FluHttp::postJson(QString url,HttpCallable* callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    QThreadPool::globalInstance()->start([=](){
        auto requestMap = toRequest(url,params,headers,"postJson");
        auto httpId = toHttpId(requestMap);
        QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
            Q_EMIT callable->finish();
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
        }
        for (int i = 0; i < retry(); ++i) {
            QNetworkAccessManager manager;
            manager.setTransferTimeout(timeout());
            QUrl _url(url);
            QNetworkRequest request(_url);
            addHeaders(&request,data["headers"].toMap());
            QString contentType = QString("application/json;charset=utf-8");
            request.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
            QEventLoop loop;
            QNetworkReply* reply = manager.post(request,QJsonDocument::fromVariant(data["params"]).toJson());
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){
                loop.quit();
            });
            loop.exec();
            QString result = QString::fromUtf8(reply->readAll());
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(httpId,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        Q_EMIT callable->cache(readCache(httpId));
                    }
                    Q_EMIT callable->error(status,errorString,result);
                }
            }
        }
        Q_EMIT callable->finish();
    });
}

void FluHttp::get(QString url,HttpCallable* callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    QThreadPool::globalInstance()->start([=](){
        auto requestMap = toRequest(url,params,headers,"get");
        auto httpId = toHttpId(requestMap);
        QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
        }
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(httpId)){
            Q_EMIT callable->cache(readCache(httpId));
            Q_EMIT callable->finish();
            return;
        }
        for (int i = 0; i < retry(); ++i) {
            QNetworkAccessManager manager;
            manager.setTransferTimeout(timeout());
            QUrl _url(url);
            addQueryParam(&_url,data["params"].toMap());
            QNetworkRequest request(_url);
            addHeaders(&request,data["headers"].toMap());
            QEventLoop loop;
            QNetworkReply* reply = manager.get(request);
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){
                loop.quit();
            });
            loop.exec();
            QString result = QString::fromUtf8(reply->readAll());
            int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            QString errorString = reply->errorString();
            bool isSuccess = reply->error() == QNetworkReply::NoError;
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(httpId,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(httpId)){
                        Q_EMIT callable->cache(readCache(httpId));
                    }
                    Q_EMIT callable->error(status,errorString,result);
                }
            }
        }
        Q_EMIT callable->finish();
    });
}

void FluHttp::download(QString url,HttpCallable* callable,QString savePath,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    QThreadPool::globalInstance()->start([=](){
        auto requestMap = toRequest(url,params,headers,"download");
        requestMap.insert("savePath",savePath);
        auto httpId = toHttpId(requestMap);
        QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
        Q_EMIT callable->start();
        QNetworkAccessManager manager;
        QUrl _url(url);
        addQueryParam(&_url,data["params"].toMap());
        QNetworkRequest request(_url);
        addHeaders(&request,data["headers"].toMap());
        QSharedPointer<QFile> file(new QFile(savePath));
        QDir dir = QFileInfo(savePath).path();
        if (!dir.exists(dir.path())){
            dir.mkpath(dir.path());
        }
        QEventLoop loop;
        connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){
            loop.quit();
        });
        qint64 seek = 0;
        auto filePath = getCacheFilePath(httpId);
        QSharedPointer<QFile> fileCache(new QFile(filePath));
        if(fileCache->exists() && file->exists() && _breakPointDownload){
            QJsonObject cacheInfo = QJsonDocument::fromJson(readCache(httpId).toUtf8()).object();
            qint64 fileSize = cacheInfo.value("fileSize").toDouble();
            qint64 contentLength = cacheInfo.value("contentLength").toDouble();
            if(fileSize == contentLength && file->size() == contentLength){
                Q_EMIT callable->downloadProgress(fileSize,contentLength);
                Q_EMIT callable->success(savePath);
                Q_EMIT callable->finish();
                return;
            }
            if(fileSize==file->size()){
                request.setRawHeader("Range", QString("bytes=%1-").arg(fileSize).toUtf8());
                seek = fileSize;
                file->open(QIODevice::WriteOnly|QIODevice::Append);
            }else{
                file->open(QIODevice::WriteOnly|QIODevice::Truncate);
            }
        }else{
            file->open(QIODevice::WriteOnly|QIODevice::Truncate);
        }
        QNetworkReply* reply =  manager.get(request);
        _cacheReply.append(reply);
        if (!fileCache->open(QIODevice::WriteOnly|QIODevice::Truncate))
        {
            qDebug()<<"FileCache Error";
        }
        connect(reply,&QNetworkReply::readyRead,reply,[reply,file,fileCache,requestMap,callable,seek]{
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
            Q_EMIT callable->downloadProgress(file->size(),contentLength);
        });
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            Q_EMIT callable->success(savePath);
        }else{
            Q_EMIT callable->error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString(),"");
        }
        reply->deleteLater();
        reply = nullptr;
        Q_EMIT callable->finish();
    });
}

void FluHttp::upload(QString url,HttpCallable* callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    QThreadPool::globalInstance()->start([=](){
        auto requestMap = toRequest(url,params,headers,"upload");
        QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
        Q_EMIT callable->start();
        QNetworkAccessManager manager;
        manager.setTransferTimeout(timeout());
        QUrl _url(url);
        QNetworkRequest request(_url);
        addHeaders(&request,data["headers"].toMap());
        QHttpMultiPart multiPart(QHttpMultiPart::FormDataType);
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
        QNetworkReply* reply = manager.post(request,&multiPart);
        _cacheReply.append(reply);
        connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){
            loop.quit();
        });
        connect(reply,&QNetworkReply::uploadProgress,reply,[=](qint64 bytesSent, qint64 bytesTotal){
            Q_EMIT callable->uploadProgress(bytesSent,bytesTotal);
        });
        loop.exec();
        QString result = QString::fromUtf8(reply->readAll());
        int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        QString errorString = reply->errorString();
        bool isSuccess = reply->error() == QNetworkReply::NoError;
        reply->deleteLater();
        reply = nullptr;
        if (isSuccess) {
            Q_EMIT callable->success(result);
        }else{
            Q_EMIT callable->error(status,errorString,result);
        }
        Q_EMIT callable->finish();
    });
}

QMap<QString, QVariant> FluHttp::toRequest(const QString& url,const QVariant& params,const QVariant& headers,const QString& method){
    QMap<QString, QVariant> request = {
        {"url",url},
        {"params",params},
        {"headers",headers},
        {"method",method}
    };
    return request;
}

QVariant FluHttp::invokeIntercept(QMap<QString, QVariant> request,Qt::ConnectionType type){
    if(!FluApp::getInstance()->httpInterceptor()){
        return request;
    }
    QVariant target;
    QMetaObject::invokeMethod(FluApp::getInstance()->httpInterceptor(), "onIntercept",type,Q_RETURN_ARG(QVariant,target),Q_ARG(QVariant, request));
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

qreal FluHttp::breakPointDownloadProgress(QString url,QString savePath,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    auto requestMap = toRequest(url,params,headers,"download");
    requestMap.insert("savePath",savePath);
    auto httpId = toHttpId(requestMap);
    QSharedPointer<QFile> file(new QFile(savePath));
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

QString FluHttp::toHttpId(const QMap<QString, QVariant>& map){
    return FluTools::getInstance()->sha256(QJsonDocument::fromVariant(QVariant(map)).toJson());
}
