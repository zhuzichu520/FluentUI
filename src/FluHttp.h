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
    QML_NAMED_ELEMENT(HttpRequest)
public:
    explicit HttpRequest(QObject *parent = nullptr);
    ~HttpRequest(){
        qDebug()<<"------------析构了"<<url();
    }
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
    QMap<QString, QVariant> toRequest(const QString& url,const QVariant& params,const QVariant& headers,const QString& method);
    QString toHttpId(const QMap<QString, QVariant>& map);
    void addQueryParam(QUrl* url,const QMap<QString, QVariant>& params);
    void addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& params);
    void handleCache(const QString& httpId, const QString& result);
    QString readCache(const QString& httpId);
    bool cacheExists(const QString& httpId);
    QString getCacheFilePath(const QString& httpId);
    void onStart(QPointer<HttpCallable> callable);
    void onFinish(QPointer<HttpCallable> callable);
    void onError(QPointer<HttpCallable> callable,int status,QString errorString,QString result);
    void onSuccess(QPointer<HttpCallable> callable,QString result);
    void onCache(QPointer<HttpCallable> callable,QString result);
    void onDownloadProgress(QPointer<HttpCallable> callable,qint64 recv,qint64 total);
    void onUploadProgress(QPointer<HttpCallable> callable,qint64 sent,qint64 total);
public:
    explicit FluHttp(QObject *parent = nullptr);
    ~FluHttp();
    Q_INVOKABLE  HttpRequest* newRequest();
    Q_INVOKABLE void get2(HttpRequest* request,HttpCallable* callable);
    //神坑！！！ 如果参数使用QVariantMap会有问题，在6.4.3版本中QML一调用就会编译失败。所以改用QMap<QString, QVariant>
    Q_INVOKABLE void get(QString url,HttpCallable* callable,QMap<QString, QVariant> params= {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void post(QString url,HttpCallable* callable,QMap<QString, QVariant> params= {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void postString(QString url,HttpCallable* callable,QString params = "",QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void postJson(QString url,HttpCallable* callable,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void download(QString url,HttpCallable* callable,QString savePath,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void upload(QString url,HttpCallable* callable,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE qreal breakPointDownloadProgress(QString url,QString savePath,QMap<QString, QVariant> params = {},QMap<QString, QVariant> headers = {});
    Q_INVOKABLE void cancel();
private:
    QList<QPointer<QNetworkReply>> _cacheReply;
};

#endif // FLUHTTP_H
