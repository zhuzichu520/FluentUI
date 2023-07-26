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
    QML_NAMED_ELEMENT(FluHttp)
private:
    QVariant invokeIntercept(const QVariant& params,const QVariant& headers,const QString& method);
    void handleReply(QNetworkReply* reply);
    void addQueryParam(QUrl* url,const QMap<QString, QVariant>& params);
    void addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& params);
    void onStart(const QJSValue& callable);
    void onFinish(const QJSValue& callable);
    void onError(const QJSValue& callable,int status,QString errorString);
    void onSuccess(const QJSValue& callable,QString result);
    void onDownloadProgress(const QJSValue& callable,qint64 recv, qint64 total);
public:
    explicit FluHttp(QObject *parent = nullptr);
    ~FluHttp();
    Q_INVOKABLE void get(QString url,QJSValue callable,QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void post(QString url,QJSValue callable,QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void postString(QString url,QJSValue callable,QString params = "",QVariantMap headers = {});
    Q_INVOKABLE void postJson(QString url,QJSValue callable,QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void download(QString url,QJSValue callable,QString filePath,QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void cancel();
private:
    QList<QPointer<QNetworkReply>> _cache;
};

#endif // FLUHTTP_H
