#include "FluNetwork.h"

#include <QUrlQuery>
#include <QBuffer>
#include <QHttpMultiPart>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonArray>

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

NetworkParams* NetworkParams::setTimeOut(int val){
    _timeout = val;
    return this;
}

NetworkParams* NetworkParams::setRetry(int val){
    _retry = val;
    return this;
}

void NetworkParams::go(NetworkCallable* callable){
    FluNetwork::getInstance()->handle(this,callable);
}

void FluNetwork::handle(NetworkParams* params,NetworkCallable* c){
    std::shared_ptr<int> times = std::make_shared<int>(0);
    QPointer<NetworkCallable> callable(c);
    if(!callable.isNull()){
        callable->start();
    }
    QUrl url(params->_url);
    QNetworkAccessManager* manager = new QNetworkAccessManager();
    QNetworkReply *reply = nullptr;
    manager->setTransferTimeout(params->getTimeout());
    addQueryParam(&url,params->_queryMap);
    QNetworkRequest request(url);
    addHeaders(&request,params->_headerMap);
    connect(manager,&QNetworkAccessManager::finished,this,[this,params,request,callable,manager,times](QNetworkReply *reply){
        if(reply->error() != QNetworkReply::NoError && *times < params->getRetry()) {
            (*times)++;
            sendRequest(manager,request,params,reply);
        } else {
            QString response = QString::fromUtf8(reply->readAll());
            QNetworkReply::NetworkError error = reply->error();
            if(error == QNetworkReply::NoError){
                if(!callable.isNull()){
                    callable->success(response);
                }
            }else{
                if(!callable.isNull()){
                    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
                    callable->error(httpStatus,reply->errorString(),response);
                }
            }
            reply->deleteLater();
            manager->deleteLater();
            if(!callable.isNull()){
                callable->finish();
            }
        }
    });
    sendRequest(manager,request,params,reply);
}

void FluNetwork::sendRequest(QNetworkAccessManager* manager,QNetworkRequest request,NetworkParams* params,QNetworkReply*& reply){
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
        reply = manager->sendCustomRequest(request,verb,multiPart);
        multiPart->setParent(reply);
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
