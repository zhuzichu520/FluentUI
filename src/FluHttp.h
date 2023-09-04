#ifndef FLUHTTP_H
#define FLUHTTP_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QFile>
#include <QNetworkAccessManager>
#include "stdafx.h"
#include <QMutex>

class HttpCallable : public QObject{
    Q_OBJECT
    QML_NAMED_ELEMENT(HttpCallable)
public:
    explicit HttpCallable(QObject *parent = nullptr);
    Q_SIGNAL void start();
    Q_SIGNAL void finish();
    Q_SIGNAL void error(int status,QString errorString,QString result);
    Q_SIGNAL void success(QString result);
    Q_SIGNAL void cache(QString result);
    Q_SIGNAL void downloadProgress(qint64 recv, qint64 total);
    Q_SIGNAL void uploadProgress(qint64 recv, qint64 total);
};

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
    void handleCache(QMap<QString, QVariant> request, const QString& result);
    QString readCache(const QMap<QString, QVariant>& request);
    bool cacheExists(const QMap<QString, QVariant>& request);
    QString getCacheFilePath(const QMap<QString, QVariant>& request);
public:
    explicit FluHttp(QObject *parent = nullptr);
    ~FluHttp();
    //神坑！！！ 如果参数使用QVariantMap会有问题，在6.4.3版本中QML一调用就会编译失败。所以改用QMap<QString, QVariant>
    Q_INVOKABLE void get(QString url,HttpCallable* callable,QMap<QString, QVariant> params= {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void post(QString url,HttpCallable* callable,QMap<QString, QVariant> params= {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void postString(QString url,HttpCallable* callable,QString params = "",QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void postJson(QString url,HttpCallable* callable,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void download(QString url,HttpCallable* callable,QString filePath,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void upload(QString url,HttpCallable* callable,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void cancel();
private:
    QList<QPointer<QNetworkReply>> _cacheReply;
};

#endif // FLUHTTP_H
