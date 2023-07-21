#ifndef FLUHTTP_H
#define FLUHTTP_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QNetworkAccessManager>
#include "stdafx.h"

class FluHttp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,url);
    Q_PROPERTY_AUTO(bool,enabledBreakpointDownload)
    Q_PROPERTY_AUTO(int,timeout)
    Q_PROPERTY_AUTO(int,retry);
private:
    QVariant invokeIntercept(const QVariant& params,const QVariant& headers,const QString& method);
public:
    explicit FluHttp(QObject *parent = nullptr);
    Q_SIGNAL void start();
    Q_SIGNAL void finish();
    Q_SIGNAL void error(int status,QString errorString);
    Q_SIGNAL void success(QString result);
    Q_SIGNAL void downloadProgress(qint64 recv, qint64 total);
    Q_INVOKABLE void get(QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void post(QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void postJson(QVariantMap params = {},QVariantMap headers = {});
    Q_INVOKABLE void postString(QString params = "",QVariantMap headers = {});

    Q_INVOKABLE void download(QString path,QVariantMap params = {},QVariantMap headers = {});
};

#endif // FLUHTTP_H
