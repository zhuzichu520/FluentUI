#ifndef FLUAPP_H
#define FLUAPP_H

#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QJsonArray>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include "FluRegister.h"
#include "FluHttpInterceptor.h"
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The FluApp class
 */
class FluApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,initialRoute);
    Q_PROPERTY_AUTO(QJsonObject,routes);
    Q_PROPERTY_AUTO(FluHttpInterceptor*,httpInterceptor);
    QML_NAMED_ELEMENT(FluApp)
    QML_SINGLETON
private:
    explicit FluApp(QObject *parent = nullptr);
    ~FluApp();
public:
    SINGLETONG(FluApp)
    static FluApp *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
    Q_INVOKABLE void run();
    Q_INVOKABLE void navigate(const QString& route,const QJsonObject& argument  = {},FluRegister* fluRegister = nullptr);
    Q_INVOKABLE void init(QQuickWindow *window);
    Q_INVOKABLE QJsonArray awesomelist(const QString& keyword = "");
    Q_INVOKABLE void closeApp();
    Q_INVOKABLE void deleteWindow(QQuickWindow* window);
public:
    QMap<quint64, QQuickWindow*> wnds;
private:
    QWindow *appWindow;
};

#endif // FLUAPP_H
