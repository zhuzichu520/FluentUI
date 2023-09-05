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

void FluHttp::handleReply(QNetworkReply* reply){
    _cacheReply.append(reply);
}

void FluHttp::post(QString url,HttpCallable* callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    QThreadPool::globalInstance()->start([=](){
        QMap<QString, QVariant> data = invokeIntercept(toRequest(url,params,headers,"post")).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
            Q_EMIT callable->finish();
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
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
            _cacheReply.removeOne(reply);
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(data,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(data)){
                        Q_EMIT callable->cache(readCache(data));
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
        QMap<QString, QVariant> data = invokeIntercept(toRequest(url,params,headers,"postString")).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
            Q_EMIT callable->finish();
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
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
            _cacheReply.removeOne(reply);
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(data,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(data)){
                        Q_EMIT callable->cache(readCache(data));
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
        QMap<QString, QVariant> data = invokeIntercept(toRequest(url,params,headers,"postJson")).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
            Q_EMIT callable->finish();
            return;
        }
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
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
            _cacheReply.removeOne(reply);
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(data,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(data)){
                        Q_EMIT callable->cache(readCache(data));
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
        QMap<QString, QVariant> data = invokeIntercept(toRequest(url,params,headers,"get")).toMap();
        Q_EMIT callable->start();
        if(_cacheMode == FluHttpType::CacheMode::FirstCacheThenRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
        }
        if(_cacheMode == FluHttpType::CacheMode::IfNoneCacheRequest && cacheExists(data)){
            Q_EMIT callable->cache(readCache(data));
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
            _cacheReply.removeOne(reply);
            reply->deleteLater();
            reply = nullptr;
            if (isSuccess) {
                handleCache(data,result);
                Q_EMIT callable->success(result);
                break;
            }else{
                if(i == retry()-1){
                    if(_cacheMode == FluHttpType::CacheMode::RequestFailedReadCache && cacheExists(data)){
                        Q_EMIT callable->cache(readCache(data));
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
        QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
        Q_EMIT callable->start();
        QNetworkAccessManager manager;
        QUrl _url(url);
        addQueryParam(&_url,data["params"].toMap());
        QNetworkRequest request(_url);
        addHeaders(&request,data["headers"].toMap());
        QSharedPointer<QFile> file(new QFile(savePath));
        QIODevice::OpenMode mode = QIODevice::WriteOnly|QIODevice::Truncate;
        if (!file->open(mode))
        {
            Q_EMIT callable->error(-1,QString("Url: %1 %2 Non-Writable").arg(request.url().toString(),file->fileName()),"");
            Q_EMIT callable->finish();
            return;
        }
        QEventLoop loop;
        connect(&manager,&QNetworkAccessManager::finished,&manager,[&loop](QNetworkReply *reply){
            loop.quit();
        });
        QNetworkReply* reply =  manager.get(request);
        _cacheReply.append(reply);
        auto filePath = getCacheFilePath(data);
        QSharedPointer<QFile> fileCache(new QFile(filePath));
        if (!fileCache->open(mode))
        {
            qDebug()<<"FileCache Error";
        }
        connect(reply,&QNetworkReply::readyRead,reply,[reply,file,fileCache,data]{
            if (!reply || !file || reply->error() != QNetworkReply::NoError)
            {
                return;
            }
            file->write(reply->readAll());
            fileCache->resize(0);
            QMap<QString, QVariant> downMap = data;
            QVariant etagHeader = reply->header(QNetworkRequest::ETagHeader);
            if (etagHeader.isValid()) {
                downMap.insert("ETag",etagHeader.toString());
            }
            downMap.insert("fileSize",file->size());
            fileCache->write(FluTools::getInstance()->toBase64(QJsonDocument::fromVariant(QVariant(downMap)).toJson()).toUtf8());
        });
        connect(reply,&QNetworkReply::downloadProgress,reply,[=](qint64 bytesReceived, qint64 bytesTotal){
            Q_EMIT callable->downloadProgress(bytesReceived,bytesTotal);
        });
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            Q_EMIT callable->success(savePath);
        }else{
            Q_EMIT callable->error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString(),"");
        }
        _cacheReply.removeOne(reply);
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
        _cacheReply.removeOne(reply);
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

QVariant FluHttp::invokeIntercept(QMap<QString, QVariant> request){
    if(!FluApp::getInstance()->httpInterceptor()){
        return request;
    }
    QVariant target;
    QMetaObject::invokeMethod(FluApp::getInstance()->httpInterceptor(), "onIntercept",Qt::BlockingQueuedConnection,Q_RETURN_ARG(QVariant,target),Q_ARG(QVariant, request));
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

QString FluHttp::readCache(const QMap<QString, QVariant>& request){
    auto filePath = getCacheFilePath(request);
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

bool FluHttp::cacheExists(const QMap<QString, QVariant>& request){
    return QFile(getCacheFilePath(request)).exists();
}

QString FluHttp::getCacheFilePath(const QMap<QString, QVariant>& request){
    auto fileName = FluTools::getInstance()->sha256(QJsonDocument::fromVariant(QVariant(request)).toJson());
    QDir dir = _cacheDir;
    if (!dir.exists(_cacheDir)){
        dir.mkpath(_cacheDir);
    }
    auto filePath = _cacheDir+"/"+fileName;
    return filePath;
}

void FluHttp::handleCache(QMap<QString, QVariant> request,const QString& result){
    if(_cacheMode==FluHttpType::CacheMode::NoCache){
        return;
    }
    auto filePath = getCacheFilePath(request);
    QSharedPointer<QFile> file(new QFile(filePath));
    QIODevice::OpenMode mode = QIODevice::WriteOnly|QIODevice::Truncate;
    if (!file->open(mode))
    {
        return;
    }
    file->write(FluTools::getInstance()->toBase64(result).toUtf8());
}
