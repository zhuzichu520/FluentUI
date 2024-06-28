#pragma once

#include <QObject>
#include <QtQml/qqml.h>
#include <QFile>
#include <QJsonValue>
#include <QJSValue>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include "src/stdafx.h"
#include "src/singleton.h"

namespace NetworkType {
    Q_NAMESPACE
    enum CacheMode {
        NoCache = 0x0000,
        RequestFailedReadCache = 0x0001,
        IfNoneCacheRequest = 0x0002,
        FirstCacheThenRequest = 0x0004,
    };

    Q_ENUM_NS(CacheMode)

    QML_NAMED_ELEMENT(NetworkType)
}

/**
 * @brief The NetworkCallable class
 */
class NetworkCallable : public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(NetworkCallable)
public:
    explicit NetworkCallable(QObject *parent = nullptr);

    Q_SIGNAL void start();

    Q_SIGNAL void finish();

    Q_SIGNAL void error(int status, QString errorString, QString result);

    Q_SIGNAL void success(QString result);

    Q_SIGNAL void cache(QString result);

    Q_SIGNAL void uploadProgress(qint64 sent, qint64 total);

    Q_SIGNAL void downloadProgress(qint64 recv, qint64 total);
};

/**
 * @brief The FluDownloadParam class
 */
class FluDownloadParam : public QObject {
    Q_OBJECT
public:
    explicit FluDownloadParam(QObject *parent = nullptr);

    FluDownloadParam(QString destPath, bool append, QObject *parent = nullptr);

public:
    QString _destPath;
    bool _append{};
};

/**
 * @brief The NetworkParams class
 */
class NetworkParams : public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(NetworkParams)
public:
    enum Method { METHOD_GET, METHOD_HEAD, METHOD_POST, METHOD_PUT, METHOD_PATCH, METHOD_DELETE };
    enum Type { TYPE_NONE, TYPE_FORM, TYPE_JSON, TYPE_JSONARRAY, TYPE_BODY };

    explicit NetworkParams(QObject *parent = nullptr);

    NetworkParams(QString url, Type type, Method method, QObject *parent = nullptr);

    Q_INVOKABLE NetworkParams *addQuery(const QString &key, const QVariant &val);

    Q_INVOKABLE NetworkParams *addHeader(const QString &key, const QVariant &val);

    Q_INVOKABLE NetworkParams *add(const QString &key, const QVariant &val);

    Q_INVOKABLE NetworkParams *addFile(const QString &key, const QVariant &val);

    Q_INVOKABLE NetworkParams *setBody(QString val);

    Q_INVOKABLE NetworkParams *setTimeout(int val);

    Q_INVOKABLE NetworkParams *setRetry(int val);

    Q_INVOKABLE NetworkParams *setCacheMode(int val);

    Q_INVOKABLE NetworkParams *toDownload(QString destPath, bool append = false);

    Q_INVOKABLE NetworkParams *bind(QObject *target);

    Q_INVOKABLE NetworkParams *openLog(QVariant val);

    Q_INVOKABLE void go(NetworkCallable *result);

    QString buildCacheKey() const;

    QString method2String() const;

    int getTimeout() const;

    int getRetry() const;

    bool getOpenLog() const;

public:
    FluDownloadParam *_downloadParam = nullptr;
    QObject *_target = nullptr;
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
    int _cacheMode = NetworkType::CacheMode::NoCache;
};

/**
 * @brief The Network class
 */
class Network : public QObject {
    Q_OBJECT
    Q_PROPERTY_AUTO(int, timeout)
    Q_PROPERTY_AUTO(int, retry)
    Q_PROPERTY_AUTO(QString, cacheDir)
    Q_PROPERTY_AUTO(bool, openLog)
    QML_NAMED_ELEMENT(Network)
    QML_SINGLETON

private:
    explicit Network(QObject *parent = nullptr);

public:
    SINGLETON(Network)

    static Network *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine) {
        return getInstance();
    }

    Q_INVOKABLE NetworkParams *get(const QString &url);

    Q_INVOKABLE NetworkParams *head(const QString &url);

    Q_INVOKABLE NetworkParams *postBody(const QString &url);

    Q_INVOKABLE NetworkParams *putBody(const QString &url);

    Q_INVOKABLE NetworkParams *patchBody(const QString &url);

    Q_INVOKABLE NetworkParams *deleteBody(const QString &url);

    Q_INVOKABLE NetworkParams *postForm(const QString &url);

    Q_INVOKABLE NetworkParams *putForm(const QString &url);

    Q_INVOKABLE NetworkParams *patchForm(const QString &url);

    Q_INVOKABLE NetworkParams *deleteForm(const QString &url);

    Q_INVOKABLE NetworkParams *postJson(const QString &url);

    Q_INVOKABLE NetworkParams *putJson(const QString &url);

    Q_INVOKABLE NetworkParams *patchJson(const QString &url);

    Q_INVOKABLE NetworkParams *deleteJson(const QString &url);

    Q_INVOKABLE NetworkParams *postJsonArray(const QString &url);

    Q_INVOKABLE NetworkParams *putJsonArray(const QString &url);

    Q_INVOKABLE NetworkParams *patchJsonArray(const QString &url);

    Q_INVOKABLE NetworkParams *deleteJsonArray(const QString &url);

    Q_INVOKABLE void setInterceptor(QJSValue interceptor);

    void handle(NetworkParams *params, NetworkCallable *result);

    void handleDownload(NetworkParams *params, NetworkCallable *result);

private:
    static void sendRequest(QNetworkAccessManager *manager, QNetworkRequest request,
                            NetworkParams *params, QNetworkReply *&reply, bool isFirst,
                            const QPointer<NetworkCallable> &callable);

    static void addQueryParam(QUrl *url, const QMap<QString, QVariant> &params);

    static void addHeaders(QNetworkRequest *request, const QMap<QString, QVariant> &headers);

    void saveResponse(const QString &key, const QString &response);

    QString readCache(const QString &key);

    bool cacheExists(const QString &key);

    QString getCacheFilePath(const QString &key);

    static QString headerList2String(const QList<QNetworkReply::RawHeaderPair> &data);

    static void printRequestStartLog(const QNetworkRequest &request, NetworkParams *params);

    static void printRequestEndLog(const QNetworkRequest &request, NetworkParams *params,
                                   QNetworkReply *&reply, const QString &response);

    static QString map2String(const QMap<QString, QVariant> &map);

public:
    QJSValue _interceptor;
};
