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

/**
 * @brief The NetworkCallable class
 */
class FluNetworkCallable : public QObject{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluNetworkCallable)
public:
    explicit FluNetworkCallable(QObject *parent = nullptr);
    Q_SIGNAL void start();
    Q_SIGNAL void finish();
    Q_SIGNAL void error(int status,QString errorString,QString result);
    Q_SIGNAL void success(QString result);
    Q_SIGNAL void cache(QString result);
    Q_SIGNAL void uploadProgress(qint64 sent, qint64 total);
    Q_SIGNAL void downloadProgress(qint64 recv, qint64 total);
};

/**
 * @brief The FluDownloadParam class
 */
class FluDownloadParam : public QObject{
    Q_OBJECT
public:
    explicit FluDownloadParam(QObject *parent = nullptr);
    FluDownloadParam(QString destPath,bool append,QObject *parent = nullptr);
public:
    QString _destPath;
    bool _append;
};

/**
 * @brief The FluNetworkParams class
 */
class FluNetworkParams : public QObject
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
    explicit FluNetworkParams(QObject *parent = nullptr);
    FluNetworkParams(QString url,Type type,Method method,QObject *parent = nullptr);
    Q_INVOKABLE FluNetworkParams* addQuery(QString key,QVariant val);
    Q_INVOKABLE FluNetworkParams* addHeader(QString key,QVariant val);
    Q_INVOKABLE FluNetworkParams* add(QString key,QVariant val);
    Q_INVOKABLE FluNetworkParams* addFile(QString key,QVariant val);
    Q_INVOKABLE FluNetworkParams* setBody(QString val);
    Q_INVOKABLE FluNetworkParams* setTimeout(int val);
    Q_INVOKABLE FluNetworkParams* setRetry(int val);
    Q_INVOKABLE FluNetworkParams* setCacheMode(int val);
    Q_INVOKABLE FluNetworkParams* toDownload(QString destPath,bool append = false);
    Q_INVOKABLE FluNetworkParams* bind(QObject* target);
    Q_INVOKABLE FluNetworkParams* openLog(QVariant val);
    Q_INVOKABLE void go(FluNetworkCallable* result);
    QString buildCacheKey();
    QString method2String();
    int getTimeout();
    int getRetry();
    bool getOpenLog();
public:
    FluDownloadParam* _downloadParam = nullptr;
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

/**
 * @brief The FluNetwork class
 */
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
    SINGLETON(FluNetwork)
    static FluNetwork *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
    Q_INVOKABLE FluNetworkParams* get(const QString& url);
    Q_INVOKABLE FluNetworkParams* head(const QString& url);
    Q_INVOKABLE FluNetworkParams* postBody(const QString& url);
    Q_INVOKABLE FluNetworkParams* putBody(const QString& url);
    Q_INVOKABLE FluNetworkParams* patchBody(const QString& url);
    Q_INVOKABLE FluNetworkParams* deleteBody(const QString& url);
    Q_INVOKABLE FluNetworkParams* postForm(const QString& url);
    Q_INVOKABLE FluNetworkParams* putForm(const QString& url);
    Q_INVOKABLE FluNetworkParams* patchForm(const QString& url);
    Q_INVOKABLE FluNetworkParams* deleteForm(const QString& url);
    Q_INVOKABLE FluNetworkParams* postJson(const QString& url);
    Q_INVOKABLE FluNetworkParams* putJson(const QString& url);
    Q_INVOKABLE FluNetworkParams* patchJson(const QString& url);
    Q_INVOKABLE FluNetworkParams* deleteJson(const QString& url);
    Q_INVOKABLE FluNetworkParams* postJsonArray(const QString& url);
    Q_INVOKABLE FluNetworkParams* putJsonArray(const QString& url);
    Q_INVOKABLE FluNetworkParams* patchJsonArray(const QString& url);
    Q_INVOKABLE FluNetworkParams* deleteJsonArray(const QString& url);
    Q_INVOKABLE void setInterceptor(QJSValue interceptor);
    void handle(FluNetworkParams* params,FluNetworkCallable* result);
    void handleDownload(FluNetworkParams* params,FluNetworkCallable* result);
private:
    void sendRequest(QNetworkAccessManager* manager,QNetworkRequest request,FluNetworkParams* params,QNetworkReply*& reply,bool isFirst,QPointer<FluNetworkCallable> callable);
    void addQueryParam(QUrl* url,const QMap<QString, QVariant>& params);
    void addHeaders(QNetworkRequest* request,const QMap<QString, QVariant>& headers);
    void saveResponse(QString key,QString response);
    QString readCache(const QString& key);
    bool cacheExists(const QString& key);
    QString getCacheFilePath(const QString& key);
    QString map2String(const QMap<QString, QVariant>& map);
    QString headerList2String(const QList<QNetworkReply::RawHeaderPair>& data);
    void printRequestStartLog(QNetworkRequest request,FluNetworkParams* params);
    void printRequestEndLog(QNetworkRequest request,FluNetworkParams* params,QNetworkReply*& reply,const QString& response);
public:
    QJSValue _interceptor;
};

#endif // FLUNETWORK_H
