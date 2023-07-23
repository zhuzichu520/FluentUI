#include "FluHttp.h"

#include <QThreadPool>
#include "HttpClient.h"
#include "FluApp.h"

using namespace  AeaQt;

FluHttp::FluHttp(QObject *parent)
    : QObject{parent}
{

}

FluHttp::~FluHttp(){
    cancel();
}

void FluHttp::cancel(){
    foreach (QPointer<QNetworkReply> item, _cache) {
        if(item){
            item->abort();
        }
    }
}

void FluHttp::handleReply(QNetworkReply* reply){
    _cache.append(reply);
}

void FluHttp::postString(QString params,QVariantMap headers){
    QVariantMap data = invokeIntercept(params,headers,"postString").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        QNetworkAccessManager manager;
        QUrl url(_url);
        QNetworkRequest request(url);
        addHeaders(&request,data["headers"].toMap());
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
        QString contentType = QString("multipart/form-data;boundary=%1").arg(multiPart->boundary());
        request.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
        for (const auto& each : data["params"].toMap().toStdMap())
        {
            const QString& key = each.first;
            const QString& value = each.second.toString();
            QString dispositionHeader = QString("form-data; name=\"%1\"").arg(key);
            QHttpPart part;
            part.setHeader(QNetworkRequest::ContentDispositionHeader, dispositionHeader);
            part.setBody(value.toUtf8());
            multiPart->append(part);
        }
        QEventLoop loop;
        QNetworkReply* reply = manager.post(request,multiPart);
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            Q_EMIT success(QString::fromUtf8(reply->readAll()));
        }else{
            Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
        }
        reply->deleteLater();
        reply = nullptr;
        Q_EMIT finish();
    });
}

void FluHttp::post(QVariantMap params,QVariantMap headers){
    QVariantMap data = invokeIntercept(params,headers,"post").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        QNetworkAccessManager manager;
        QUrl url(_url);
        QNetworkRequest request(url);
        addHeaders(&request,data["headers"].toMap());
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
        QString contentType = QString("multipart/form-data;boundary=%1").arg(multiPart->boundary());
         request.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
        for (const auto& each : data["params"].toMap().toStdMap())
        {
            const QString& key = each.first;
            const QString& value = each.second.toString();
            QString dispositionHeader = QString("form-data; name=\"%1\"").arg(key);
            QHttpPart part;
            part.setHeader(QNetworkRequest::ContentDispositionHeader, dispositionHeader);
            part.setBody(value.toUtf8());
            multiPart->append(part);
        }
        QEventLoop loop;
        QNetworkReply* reply = manager.post(request,multiPart);
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            Q_EMIT success(QString::fromUtf8(reply->readAll()));
        }else{
            Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
        }
        reply->deleteLater();
        reply = nullptr;
        Q_EMIT finish();
    });
}

void FluHttp::postJson(QVariantMap params,QVariantMap headers){
    QVariantMap data = invokeIntercept(params,headers,"postJson").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        QNetworkAccessManager manager;
        QUrl url(_url);
        QNetworkRequest request(url);
        addHeaders(&request,data["headers"].toMap());
        QHttpMultiPart* multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
        QString contentType = QString("multipart/form-data;boundary=%1").arg(multiPart->boundary());
        request.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
        for (const auto& each : data["params"].toMap().toStdMap())
        {
            const QString& key = each.first;
            const QString& value = each.second.toString();
            QString dispositionHeader = QString("form-data; name=\"%1\"").arg(key);
            QHttpPart part;
            part.setHeader(QNetworkRequest::ContentDispositionHeader, dispositionHeader);
            part.setBody(value.toUtf8());
            multiPart->append(part);
        }
        QEventLoop loop;
        QNetworkReply* reply = manager.post(request,multiPart);
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            Q_EMIT success(QString::fromUtf8(reply->readAll()));
        }else{
            Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
        }
        reply->deleteLater();
        reply = nullptr;
        Q_EMIT finish();
    });
}

void FluHttp::get(QVariantMap params,QVariantMap headers){
    QVariantMap data = invokeIntercept(params,headers,"get").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        QNetworkAccessManager manager;
        QUrl url(_url);
        addQueryParam(&url,data["params"].toMap());
        QNetworkRequest request(url);
        addHeaders(&request,data["headers"].toMap());
        QEventLoop loop;
        QNetworkReply* reply = manager.get(request);
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();
        if (reply->error() == QNetworkReply::NoError) {
            Q_EMIT success(QString::fromUtf8(reply->readAll()));
        }else{
            Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
        }
        reply->deleteLater();
        reply = nullptr;
        Q_EMIT finish();
    });
}

void FluHttp::download(QString path,QVariantMap params,QVariantMap headers){
    QVariantMap data = invokeIntercept(params,headers,"download").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        QNetworkAccessManager manager;
        QUrl url(_url);
        addQueryParam(&url,data["params"].toMap());
        QNetworkRequest request(url);
        addHeaders(&request,data["headers"].toMap());
        QFile *file = new QFile(path);
        QIODevice::OpenMode mode = QIODevice::WriteOnly|QIODevice::Truncate;
        if (!file->open(mode))
        {
            Q_EMIT error(-1,QString("Url: %1 %2 Non-Writable").arg(request.url().toString(),file->fileName()));
            file->deleteLater();
            file = nullptr;
            Q_EMIT finish();
            return;
        }
        QEventLoop *loop = new QEventLoop();
        connect(&manager,&QNetworkAccessManager::finished,this,[=](QNetworkReply *reply){
            loop->quit();
        });
        QPointer<QNetworkReply> reply =  manager.get(request);
        _cache.append(reply);
        connect(reply,&QNetworkReply::downloadProgress,this,[=](qint64 bytesReceived, qint64 bytesTotal){
            Q_EMIT downloadProgress(bytesReceived,bytesTotal);
        });
        connect(reply,&QNetworkReply::readyRead,this,[=](){
            file->write(reply->readAll());
        });
        loop->exec();
        if (reply->error() == QNetworkReply::NoError) {
            Q_EMIT success(path);
        }else{
            Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
        }
        file->close();
        loop->deleteLater();
        file->deleteLater();
        reply->deleteLater();
        loop = nullptr;
        file = nullptr;
        reply = nullptr;
        Q_EMIT finish();
    });
}

QVariant FluHttp::invokeIntercept(const QVariant& params,const QVariant& headers,const QString& method){
    QVariantMap requet = {
        {"params",params},
        {"headers",headers},
        {"method",method}
    };
    if(!FluApp::getInstance()->httpInterceptor()){
        return requet;
    }
    QVariant target;
    QMetaObject::invokeMethod(FluApp::getInstance()->httpInterceptor(), "onIntercept",Q_RETURN_ARG(QVariant,target),Q_ARG(QVariant, requet));
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
