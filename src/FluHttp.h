#ifndef FLUHTTP_H
#define FLUHTTP_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QFile>
#include <QNetworkAccessManager>
#include "stdafx.h"

class FluHttp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(int,retry);
    Q_PROPERTY_AUTO(int,timeout)
    Q_PROPERTY_AUTO(int,cacheMode);
    Q_PROPERTY_AUTO(QString,cacheDir);
    QML_NAMED_ELEMENT(FluHttp)
private:
    QVariant invokeIntercept(QMap<QString, QVariant> request);
    QMap<QString, QVariant> toRequest(const QString& url,const QVariant& params,const QVariant& headers,const QString& method);
    void handleReply(QNetworkReply* reply);
    void addQueryParam(QUrl* url,const QMap<QString, QVariant>& params);
    void addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& params);
    void onStart(const QJSValue& callable);
    void onFinish(const QJSValue& callable);
    void onError(const QJSValue& callable,int status,QString errorString,QString result);
    void onSuccess(const QJSValue& callable,QString result);
    void onDownloadProgress(const QJSValue& callable,qint64 recv, qint64 total);
    void onUploadProgress(const QJSValue& callable,qint64 recv, qint64 total);
    void handleCache(QMap<QString, QVariant> request, const QString& result);
public:
    explicit FluHttp(QObject *parent = nullptr);
    ~FluHttp();
    //神坑！！！ 如果参数使用QVariantMap会有问题，在6.4.3版本中QML一调用就会编译失败。所以改用QMap<QString, QVariant>
    Q_INVOKABLE void get(QString url,QJSValue callable,QMap<QString, QVariant> params= {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void post(QString url,QJSValue callable,QMap<QString, QVariant> params= {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void postString(QString url,QJSValue callable,QString params = "",QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void postJson(QString url,QJSValue callable,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void download(QString url,QJSValue callable,QString filePath,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void upload(QString url,QJSValue callable,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void cancel();
private:
    QList<QPointer<QNetworkReply>> _cacheReply;
};

#endif // FLUHTTP_H
