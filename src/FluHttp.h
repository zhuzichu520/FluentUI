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
    Q_PROPERTY_AUTO(QString,url);
    QML_NAMED_ELEMENT(FluHttp)
private:
    QVariant invokeIntercept(const QVariant& params,const QVariant& headers,const QString& method);
    void handleReply(QNetworkReply* reply);
    void addQueryParam(QUrl* url,const QMap<QString, QVariant>& params);
    void addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& params);
public:
    explicit FluHttp(QObject *parent = nullptr);
    ~FluHttp();
    Q_SIGNAL void start();
    Q_SIGNAL void finish();
    Q_SIGNAL void error(int status,QString errorString);
    Q_SIGNAL void success(QString result);
    Q_SIGNAL void downloadProgress(qint64 recv, qint64 total);
    Q_INVOKABLE void get(QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void post(QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void download(QString path,QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void cancel();
private:
    QList<QPointer<QNetworkReply>> _cache;
};

#endif // FLUHTTP_H
