#ifndef FLUHTTP_H
#define FLUHTTP_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QFile>
#include <QNetworkAccessManager>
#include "stdafx.h"

class HttpRequest : public QObject{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,url);
    Q_PROPERTY_AUTO(QVariant,params);
    Q_PROPERTY_AUTO(QVariant,headers);
    Q_PROPERTY_AUTO(QString,method);
    Q_PROPERTY_AUTO(QString,downloadSavePath);
    QML_NAMED_ELEMENT(HttpRequest)
public:
    explicit HttpRequest(QObject *parent = nullptr);
    QMap<QString, QVariant> toMap();
    Q_INVOKABLE QString httpId();
};

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
    Q_SIGNAL void uploadProgress(qint64 sent, qint64 total);
};

class FluHttp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(int,retry);
    Q_PROPERTY_AUTO(int,timeout)
    Q_PROPERTY_AUTO(int,cacheMode);
    Q_PROPERTY_AUTO(QString,cacheDir);
    Q_PROPERTY_AUTO(bool,breakPointDownload);
    QML_NAMED_ELEMENT(FluHttp)
private:
    QVariant invokeIntercept(QMap<QString, QVariant> request);
    void addQueryParam(QUrl* url,const QMap<QString, QVariant>& params);
    void addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& params);
    void handleCache(const QString& httpId, const QString& result);
    QString readCache(const QString& httpId);
    bool cacheExists(const QString& httpId);
    QString getCacheFilePath(const QString& httpId);
    void onStart(QPointer<HttpCallable> callable);
    void onFinish(QPointer<HttpCallable> callable,HttpRequest* request);
    void onError(QPointer<HttpCallable> callable,int status,QString errorString,QString result);
    void onSuccess(QPointer<HttpCallable> callable,QString result);
    void onCache(QPointer<HttpCallable> callable,QString result);
    void onDownloadProgress(QPointer<HttpCallable> callable,qint64 recv,qint64 total);
    void onUploadProgress(QPointer<HttpCallable> callable,qint64 sent,qint64 total);
public:
    explicit FluHttp(QObject *parent = nullptr);
    ~FluHttp();
    Q_INVOKABLE  HttpRequest* newRequest(QString url = "");
    Q_INVOKABLE void get(HttpRequest* request,HttpCallable* callable);
    Q_INVOKABLE void post(HttpRequest* request,HttpCallable* callable);
    Q_INVOKABLE void postString(HttpRequest* request,HttpCallable* callable);
    Q_INVOKABLE void postJson(HttpRequest* request,HttpCallable* callable);
    Q_INVOKABLE void download(HttpRequest* request,HttpCallable* callable);
    Q_INVOKABLE void upload(HttpRequest* request,HttpCallable* callable);
    Q_INVOKABLE qreal getBreakPointProgress(HttpRequest* request);
    Q_INVOKABLE void cancel();
private:
    QList<QPointer<QNetworkReply>> _cacheReply;
};

#endif // FLUHTTP_H
