#include "FluHttp.h"

#include <QThreadPool>
#include "HttpClient.h"
#include "FluApp.h"

using namespace  AeaQt;

FluHttp::FluHttp(QObject *parent)
    : QObject{parent}
{
    enabledBreakpointDownload(false);
    timeout(15);
    retry(3);

}

FluHttp::~FluHttp(){
    cancel();
}

void FluHttp::cancel(){
    foreach (auto item, cache) {
        if(item){
            qDebug()<<item;
            item->abort();
        }
    }
}

void FluHttp::handleReply(QNetworkReply* reply){
    cache.append(reply);
}

void FluHttp::postString(QString params,QVariantMap headers){
    QVariantMap request = invokeIntercept(params,headers,"postString").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        HttpClient client;
        client.initReplyCompleted = [=](QNetworkReply* reply){ handleReply(reply); };
        client.post(_url)
            .retry(retry())
            .timeout(timeout())
            .bodyWithRaw(request[params].toString().toUtf8())
            .headers(request["headers"].toMap())
            .onSuccess([=](QString result) {
                Q_EMIT success(result);
            })
            .onFailed([=](QNetworkReply* reply) {
                Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
            })
            .block()
            .exec();
        Q_EMIT finish();
    });
}

void FluHttp::post(QVariantMap params,QVariantMap headers){
    QVariantMap request = invokeIntercept(params,headers,"post").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        HttpClient client;
        client.initReplyCompleted = [=](QNetworkReply* reply){ handleReply(reply); };
        client.post(_url)
            .retry(retry())
            .timeout(timeout())
            .headers(headers)
            .bodyWithFormData(request["params"].toMap())
            .headers(request["headers"].toMap())
            .onSuccess([=](QString result) {
                Q_EMIT success(result);
            })
            .onFailed([=](QNetworkReply* reply) {
                Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
            })
            .block()
            .exec();
        Q_EMIT finish();
    });
}

void FluHttp::postJson(QVariantMap params,QVariantMap headers){
    QVariantMap request = invokeIntercept(params,headers,"postJson").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        HttpClient client;
        client.initReplyCompleted = [=](QNetworkReply* reply){ handleReply(reply); };
        client.post(_url)
            .retry(retry())
            .timeout(timeout())
            .headers(headers)
            .bodyWithRaw(QJsonDocument::fromVariant(request["params"]).toJson())
            .headers(request["headers"].toMap())
            .onSuccess([=](QString result) {
                Q_EMIT success(result);
            })
            .onFailed([=](QNetworkReply* reply) {
                Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
            })
            .block()
            .exec();
        Q_EMIT finish();
    });
}

void FluHttp::get(QVariantMap params,QVariantMap headers){
    QVariantMap request = invokeIntercept(params,headers,"get").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        HttpClient client;
        client.initReplyCompleted = [=](QNetworkReply* reply){ handleReply(reply); };
        client.get(_url)
            .retry(retry())
            .timeout(timeout())
            .queryParams(request["params"].toMap())
            .headers(request["headers"].toMap())
            .onSuccess([=](QString result) {
                Q_EMIT success(result);
            })
            .onFailed([=](QNetworkReply* reply) {
                Q_EMIT error(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt(),reply->errorString());
            })
            .block()
            .exec();
        Q_EMIT finish();
    });
}

void FluHttp::download(QString path,QVariantMap params,QVariantMap headers){
    QPointer<FluHttp> weakThis(this);
    QVariantMap request = invokeIntercept(params,headers,"download").toMap();
    QThreadPool::globalInstance()->start([=](){
        Q_EMIT start();
        HttpClient client;
        client.initReplyCompleted = [=](QNetworkReply* reply){ handleReply(reply); };
        client.get(_url)
            .retry(retry())
            .timeout(timeout())
            .download(path)
            .enabledBreakpointDownload(_enabledBreakpointDownload)
            .queryParams(request["params"].toMap())
            .headers(request["headers"].toMap())
            .onDownloadProgress([=](qint64 recv, qint64 total) {
                if (!weakThis) {
                    return;
                }
                Q_EMIT weakThis->downloadProgress(recv,total);
            })
            .onDownloadFileSuccess([=](QString result) {
                Q_EMIT success(result);
            })
            .onDownloadFileFailed([=](QString errorString) {
                Q_EMIT error(-1,errorString);
            })
            .block()
            .exec();
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
