#include "FluNetwork.h"

#include <QUrlQuery>
#include <QBuffer>
#include <QHttpMultiPart>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QJsonObject>
#include <QNetworkDiskCache>
#include <QJsonArray>
#include <QStandardPaths>
#include <QDir>

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

QString NetworkParams::buildCacheKey(){
    QJsonObject obj;
    obj.insert("url",_url);
    obj.insert("method",method2String());
    obj.insert("body",_body);
    obj.insert("query",QString(QJsonDocument::fromVariant(_queryMap).toJson(QJsonDocument::Compact)));
    obj.insert("param",QString(QJsonDocument::fromVariant(_paramMap).toJson(QJsonDocument::Compact)));
    obj.insert("header",QString(QJsonDocument::fromVariant(_headerMap).toJson(QJsonDocument::Compact)));
    obj.insert("file",QString(QJsonDocument::fromVariant(_fileMap).toJson(QJsonDocument::Compact)));
    QByteArray data = QJsonDocument(obj).toJson(QJsonDocument::Compact);
    return QCryptographicHash::hash(data, QCryptographicHash::Sha256).toHex();
}

void NetworkParams::go(NetworkCallable* callable){
    if(_downloadParam){
        FluNetwork::getInstance()->handleDownload(this,callable);
    }else{
        FluNetwork::getInstance()->handle(this,callable);
    }
}

void FluNetwork::handle(NetworkParams* params,NetworkCallable* c){
    QString cacheKey = params->buildCacheKey();
    QPointer<NetworkCallable> callable(c);
    if(!callable.isNull()){
        callable->start();
    }
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
    std::shared_ptr<int> times = std::make_shared<int>(0);
    QUrl url(params->_url);
    QNetworkAccessManager* manager = new QNetworkAccessManager();
    QNetworkReply *reply = nullptr;
    manager->setTransferTimeout(params->getTimeout());
    addQueryParam(&url,params->_queryMap);
    QNetworkRequest request(url);
    addHeaders(&request,params->_headerMap);
    connect(manager,&QNetworkAccessManager::finished,this,[this,params,request,callable,manager,times,cacheKey](QNetworkReply *reply){
        if(reply->error() != QNetworkReply::NoError && *times < params->getRetry()) {
            (*times)++;
            sendRequest(manager,request,params,reply,callable);
        } else {
            QString response = QString::fromUtf8(reply->readAll());
            QNetworkReply::NetworkError error = reply->error();
            if(error == QNetworkReply::NoError){
                if(!callable.isNull()){
                    if(params->_cacheMode != FluNetworkType::CacheMode::NoCache){
                        saveResponse(cacheKey,response);
                    }
                    callable->success(response);
                }
            }else{
                if(!callable.isNull()){
                    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
                    if(params->_cacheMode == FluNetworkType::CacheMode::RequestFailedReadCache && cacheExists(cacheKey)){
                        if(!callable.isNull()){
                            callable->cache(readCache(cacheKey));
                        }
                    }
                    callable->error(httpStatus,reply->errorString(),response);
                }
            }
            params->deleteLater();
            reply->deleteLater();
            manager->deleteLater();
            if(!callable.isNull()){
                callable->finish();
            }
        }
    });
    sendRequest(manager,request,params,reply,callable);
}

void FluNetwork::handleDownload(NetworkParams* params,NetworkCallable* result){

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

void FluNetwork::sendRequest(QNetworkAccessManager* manager,QNetworkRequest request,NetworkParams* params,QNetworkReply*& reply,QPointer<NetworkCallable> callable){
    if(reply){
        reply->deleteLater();
    }
    QByteArray verb = params->method2String().toUtf8();
    switch (params->_type) {
    case NetworkParams::TYPE_FORM:{
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
        if(!params->_fileMap.isEmpty()){
            connect(reply,&QNetworkReply::uploadProgress,reply,[callable](qint64 bytesSent, qint64 bytesTotal){
                if(!callable.isNull() && bytesSent!=0 && bytesTotal!=0){
                    callable->uploadProgress(bytesSent,bytesTotal);
                }
            });
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
    timeout(15000);
    retry(3);
    cacheDir(QStandardPaths::writableLocation(QStandardPaths::CacheLocation).append(QDir::separator()).append("network"));
}

NetworkParams* FluNetwork::get(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_NONE,NetworkParams::METHOD_GET);
}

NetworkParams* FluNetwork::head(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_NONE,NetworkParams::METHOD_HEAD);
}

NetworkParams* FluNetwork::postBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_POST);
}

NetworkParams* FluNetwork::putBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_PUT);
}

NetworkParams* FluNetwork::patchBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_PATCH);
}

NetworkParams* FluNetwork::deleteBody(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_BODY,NetworkParams::METHOD_DELETE);
}

NetworkParams* FluNetwork::postForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_POST);
}

NetworkParams* FluNetwork::putForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_PUT);
}

NetworkParams* FluNetwork::patchForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_PATCH);
}

NetworkParams* FluNetwork::deleteForm(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_FORM,NetworkParams::METHOD_DELETE);
}

NetworkParams* FluNetwork::postJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_POST);
}

NetworkParams* FluNetwork::putJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_PUT);
}

NetworkParams* FluNetwork::patchJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_PATCH);
}

NetworkParams* FluNetwork::deleteJson(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSON,NetworkParams::METHOD_DELETE);
}

NetworkParams* FluNetwork::postJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_POST);
}

NetworkParams* FluNetwork::putJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_PUT);
}

NetworkParams* FluNetwork::patchJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_PATCH);
}

NetworkParams* FluNetwork::deleteJsonArray(const QString& url){
    return new NetworkParams(url,NetworkParams::TYPE_JSONARRAY,NetworkParams::METHOD_DELETE);
}
