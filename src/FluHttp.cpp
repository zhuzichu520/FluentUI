#include "FluHttp.h"

#include <QThreadPool>
#include <QEventLoop>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QHttpMultiPart>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QDir>
#include "Def.h"
#include "MainThread.h"
#include "FluApp.h"
#include "FluTools.h"

FluHttp::FluHttp(QObject *parent)
    : QObject{parent}
{
    retry(3);
    timeout(15000);
    cacheMode(FluHttpType::CacheMode::RequestFailedReadCache);
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

void FluHttp::post(QString url,QJSValue callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    auto requestMap = toRequest(url,params,headers,"post");
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
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
            connect(&manager,&QNetworkAccessManager::finished,this,[&loop](QNetworkReply *reply){
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
                handleCache(requestMap,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    onError(callable,status,errorString,result);
                }
            }
        }
        onFinish(callable);
    });
}

void FluHttp::postString(QString url,QJSValue callable,QString params,QMap<QString, QVariant> headers){
    auto requestMap = toRequest(url,params,headers,"post");
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
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
            connect(&manager,&QNetworkAccessManager::finished,this,[&loop](QNetworkReply *reply){
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
                handleCache(requestMap,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    onError(callable,status,errorString,result);
                }
            }
        }
        onFinish(callable);
    });
}

void FluHttp::postJson(QString url,QJSValue callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    auto requestMap = toRequest(url,params,headers,"post");
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
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
            connect(&manager,&QNetworkAccessManager::finished,this,[&loop](QNetworkReply *reply){
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
                handleCache(requestMap,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    onError(callable,status,errorString,result);
                }
            }
        }
        onFinish(callable);
    });
}

void FluHttp::get(QString url,QJSValue callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    auto requestMap = toRequest(url,params,headers,"post");
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        for (int i = 0; i < retry(); ++i) {
            onStart(callable);
            QNetworkAccessManager manager;
            manager.setTransferTimeout(timeout());
            QUrl _url(url);
            addQueryParam(&_url,data["params"].toMap());
            QNetworkRequest request(_url);
            addHeaders(&request,data["headers"].toMap());
            QEventLoop loop;
            QNetworkReply* reply = manager.get(request);
            _cacheReply.append(reply);
            connect(&manager,&QNetworkAccessManager::finished,this,[&loop](QNetworkReply *reply){
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
                handleCache(requestMap,result);
                onSuccess(callable,result);
                break;
            }else{
                if(i == retry()-1){
                    onError(callable,status,errorString,result);
                }
            }
        }
        onFinish(callable);
    });
}

void FluHttp::download(QString url,QJSValue callable,QString filePath,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    auto requestMap = toRequest(url,params,headers,"post");
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
        QNetworkAccessManager manager;
        QUrl _url(url);
        addQueryParam(&_url,data["params"].toMap());
        QNetworkRequest request(_url);
        addHeaders(&request,data["headers"].toMap());
        QSharedPointer<QFile> file(new QFile(filePath));
        QIODevice::OpenMode mode = QIODevice::WriteOnly|QIODevice::Truncate;
        if (!file->open(mode))
        {
            onError(callable,-1,QString("Url: %1 %2 Non-Writable").arg(request.url().toString(),file->fileName()),"");
            onFinish(callable);
            return;
        }
        QEventLoop loop;
        connect(&manager,&QNetworkAccessManager::finished,this,[&loop](QNetworkReply *reply){
            loop.quit();
        });
        QPointer<QNetworkReply> reply =  manager.get(request);
        _cacheReply.append(reply);
        connect(reply,&QNetworkReply::downloadProgress,this,[=](qint64 bytesReceived, qint64 bytesTotal){
            onDownloadProgress(callable,bytesReceived,bytesTotal);
        });
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            file->write(reply->readAll());
            onSuccess(callable,filePath);
        }else{
            onError(callable,reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString(),"");
        }
        _cacheReply.removeOne(reply);
        reply->deleteLater();
        reply = nullptr;
        onFinish(callable);
    });
}

void FluHttp::upload(QString url,QJSValue callable,QMap<QString, QVariant> params,QMap<QString, QVariant> headers){
    auto requestMap = toRequest(url,params,headers,"post");
    QMap<QString, QVariant> data = invokeIntercept(requestMap).toMap();
    QThreadPool::globalInstance()->start([=](){
        onStart(callable);
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
        connect(&manager,&QNetworkAccessManager::finished,this,[&loop](QNetworkReply *reply){
            loop.quit();
        });
        connect(reply,&QNetworkReply::uploadProgress,this,[=](qint64 bytesSent, qint64 bytesTotal){
            onUploadProgress(callable,bytesSent,bytesTotal);
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
            onSuccess(callable,result);
        }else{
            onError(callable,status,errorString,result);
        }
        onFinish(callable);
    });
}

QMap<QString, QVariant> FluHttp::toRequest(const QString& url,const QVariant& params,const QVariant& headers,const QString& method){
    QMap<QString, QVariant> request = {
        {"url",url},
        {"params",params},
        {"headers",headers},
        {"method","upload"}
    };
    return request;
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

void FluHttp::onStart(const QJSValue& callable){
    MainThread::post([=](){
        QJSValue onStart = callable.property("onStart");
        onStart.call();
    });
}

void FluHttp::onFinish(const QJSValue& callable){
    MainThread::post([=](){
        QJSValue onFinish = callable.property("onFinish");
        onFinish.call();
    });
}

void FluHttp::onError(const QJSValue& callable,int status,QString errorString,QString result){
    MainThread::post([=](){
        QJSValue onError = callable.property("onError");
        QJSValueList args;
        args<<status<<errorString<<result;
        onError.call(args);
    });
}

void FluHttp::onSuccess(const QJSValue& callable,QString result){
    MainThread::post([=](){
        QJSValueList args;
        args<<result;
        QJSValue onSuccess = callable.property("onSuccess");
        onSuccess.call(args);
    });
}

void FluHttp::onDownloadProgress(const QJSValue& callable,qint64 recv, qint64 total){
    MainThread::post([=](){
        QJSValueList args;
        args<<static_cast<double>(recv);
        args<<static_cast<double>(total);
        QJSValue onDownloadProgress = callable.property("onDownloadProgress");
        onDownloadProgress.call(args);
    });
}

void FluHttp::onUploadProgress(const QJSValue& callable,qint64 sent, qint64 total){
    MainThread::post([=](){
        QJSValueList args;
        args<<static_cast<double>(sent);
        args<<static_cast<double>(total);
        QJSValue onUploadProgress = callable.property("onUploadProgress");
        onUploadProgress.call(args);
    });
}

void FluHttp::handleCache(QMap<QString, QVariant> request,const QString& result){
    if(_cacheMode==FluHttpType::CacheMode::NoCache){
        return;
    }
    auto fileName = FluTools::getInstance()->md5(QJsonDocument::fromVariant(QVariant(request)).toJson());
    QDir dir = _cacheDir;
    if (!dir.exists(_cacheDir)){
        dir.mkpath(_cacheDir);
    }
    auto filePath = _cacheDir+"/"+fileName;
    QSharedPointer<QFile> file(new QFile(filePath));
    QIODevice::OpenMode mode = QIODevice::WriteOnly|QIODevice::Truncate;
    if (!file->open(mode))
    {
        return;
    }
    file->write(FluTools::getInstance()->toBase64(result).toUtf8());
}
