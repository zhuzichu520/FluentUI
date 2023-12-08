#ifndef FLUNETWORK_H
#define FLUNETWORK_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QFile>
#include <QJsonValue>
#include <QJSValue>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include "Def.h"
#include "stdafx.h"
#include "singleton.h"

class NetworkCallable : public QObject{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluNetworkCallable)
public:
    explicit NetworkCallable(QObject *parent = nullptr);
    Q_SIGNAL void start();
    Q_SIGNAL void finish();
    Q_SIGNAL void error(int status,QString errorString,QString result);
    Q_SIGNAL void success(QString result);
    Q_SIGNAL void cache(QString result);
    Q_SIGNAL void uploadProgress(qint64 sent, qint64 total);
    Q_SIGNAL void downloadProgress(qint64 recv, qint64 total);
};

class DownloadParam : public QObject{
    Q_OBJECT
public:
    explicit DownloadParam(QObject *parent = nullptr);
    DownloadParam(QString destPath,bool append,QObject *parent = nullptr);
public:
    QString _destPath;
    bool _append;
};

class NetworkParams : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluNetworkParams)
public:
    enum Method{
        METHOD_GET,
        METHOD_HEAD,
        METHOD_POST,
        METHOD_PUT,
        METHOD_PATCH,
        METHOD_DELETE
    };
    enum Type{
        TYPE_NONE,
        TYPE_FORM,
        TYPE_JSON,
        TYPE_JSONARRAY,
        TYPE_BODY
    };
    explicit NetworkParams(QObject *parent = nullptr);
    NetworkParams(QString url,Type type,Method method,QObject *parent = nullptr);
    Q_INVOKABLE NetworkParams* addQuery(QString key,QVariant val);
    Q_INVOKABLE NetworkParams* addHeader(QString key,QVariant val);
    Q_INVOKABLE NetworkParams* add(QString key,QVariant val);
    Q_INVOKABLE NetworkParams* addFile(QString key,QVariant val);
    Q_INVOKABLE NetworkParams* setBody(QString val);
    Q_INVOKABLE NetworkParams* setTimeout(int val);
    Q_INVOKABLE NetworkParams* setRetry(int val);
    Q_INVOKABLE NetworkParams* setCacheMode(int val);
    Q_INVOKABLE NetworkParams* toDownload(QString destPath,bool append = false);
    Q_INVOKABLE NetworkParams* bind(QObject* target);
    Q_INVOKABLE NetworkParams* openLog(QVariant val);
    Q_INVOKABLE void go(NetworkCallable* result);
    QString buildCacheKey();
    QString method2String();
    int getTimeout();
    int getRetry();
    bool getOpenLog();
public:
    DownloadParam* _downloadParam = nullptr;
    QObject* _target = nullptr;
    Method _method;
    Type _type;
    QString _url;
    QString _body;
    QMap<QString, QVariant> _queryMap;
    QMap<QString, QVariant> _headerMap;
    QMap<QString, QVariant> _paramMap;
    QMap<QString, QVariant> _fileMap;
    int _timeout = -1;
    int _retry = -1;
    QVariant _openLog;
    int _cacheMode = FluNetworkType::CacheMode::NoCache;
};

class FluNetwork : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(int,timeout)
    Q_PROPERTY_AUTO(int,retry)
    Q_PROPERTY_AUTO(QString,cacheDir)
    Q_PROPERTY_AUTO(bool,openLog)
    QML_NAMED_ELEMENT(FluNetwork)
    QML_SINGLETON
private:
    explicit FluNetwork(QObject *parent = nullptr);
public:
    SINGLETONG(FluNetwork)
    static FluNetwork *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
    Q_INVOKABLE NetworkParams* get(const QString& url);
    Q_INVOKABLE NetworkParams* head(const QString& url);
    Q_INVOKABLE NetworkParams* postBody(const QString& url);
    Q_INVOKABLE NetworkParams* putBody(const QString& url);
    Q_INVOKABLE NetworkParams* patchBody(const QString& url);
    Q_INVOKABLE NetworkParams* deleteBody(const QString& url);
    Q_INVOKABLE NetworkParams* postForm(const QString& url);
    Q_INVOKABLE NetworkParams* putForm(const QString& url);
    Q_INVOKABLE NetworkParams* patchForm(const QString& url);
    Q_INVOKABLE NetworkParams* deleteForm(const QString& url);
    Q_INVOKABLE NetworkParams* postJson(const QString& url);
    Q_INVOKABLE NetworkParams* putJson(const QString& url);
    Q_INVOKABLE NetworkParams* patchJson(const QString& url);
    Q_INVOKABLE NetworkParams* deleteJson(const QString& url);
    Q_INVOKABLE NetworkParams* postJsonArray(const QString& url);
    Q_INVOKABLE NetworkParams* putJsonArray(const QString& url);
    Q_INVOKABLE NetworkParams* patchJsonArray(const QString& url);
    Q_INVOKABLE NetworkParams* deleteJsonArray(const QString& url);
    Q_INVOKABLE void setInterceptor(QJSValue interceptor);
    void handle(NetworkParams* params,NetworkCallable* result);
    void handleDownload(NetworkParams* params,NetworkCallable* result);
private:
    void sendRequest(QNetworkAccessManager* manager,QNetworkRequest request,NetworkParams* params,QNetworkReply*& reply,bool isFirst,QPointer<NetworkCallable> callable);
    void addQueryParam(QUrl* url,const QMap<QString, QVariant>& params);
    void addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& headers);
    void saveResponse(QString key,QString response);
    QString readCache(const QString& key);
    bool cacheExists(const QString& key);
    QString getCacheFilePath(const QString& key);
    QString map2String(const QMap<QString, QVariant>& map);
    QString headerList2String(const QList<QNetworkReply::RawHeaderPair>& data);
    void printRequestStartLog(QNetworkRequest request,NetworkParams* params);
    void printRequestEndLog(QNetworkRequest request,NetworkParams* params,QNetworkReply*& reply,const QString& response);
public:
    QJSValue _interceptor;
};

#endif // FLUNETWORK_H
