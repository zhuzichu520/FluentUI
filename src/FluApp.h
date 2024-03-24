#ifndef FLUAPP_H
#define FLUAPP_H

#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QJsonArray>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include <QTranslator>
#include <QQuickWindow>
#include "stdafx.h"
#include "singleton.h"


/**
 * @brief The FluWindowRegister class
 */
class FluWindowRegister : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QQuickWindow*,from)
    Q_PROPERTY_AUTO(QQuickWindow*,to)
    Q_PROPERTY_AUTO(QString,path);
public:
    explicit FluWindowRegister(QObject *parent = nullptr);
    Q_INVOKABLE void launch(const QJsonObject& argument  = {});
    Q_INVOKABLE void onResult(const QJsonObject& data  = {});
    Q_SIGNAL void result(const QJsonObject& data);
};

/**
 * @brief The FluApp class
 */
class FluApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,initialRoute);
    Q_PROPERTY_AUTO(QJsonObject,routes);
    Q_PROPERTY_AUTO(bool,useSystemAppBar);
    Q_PROPERTY_AUTO(QString,windowIcon);
    Q_PROPERTY_AUTO(QLocale,locale);
    QML_NAMED_ELEMENT(FluApp)
    QML_SINGLETON
private:
    explicit FluApp(QObject *parent = nullptr);
    ~FluApp();
public:
    SINGLETON(FluApp)
    static FluApp *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){return getInstance();}
    Q_INVOKABLE void run();
    Q_INVOKABLE void navigate(const QString& route,const QJsonObject& argument  = {},FluWindowRegister* windowRegister = nullptr);
    Q_INVOKABLE void init(QObject *target,QLocale locale = QLocale::system());
    Q_INVOKABLE void exit(int retCode = 0);
    Q_INVOKABLE QVariant createWindowRegister(QQuickWindow* window,const QString& path);
    void addWindow(QQuickWindow* window);
    void removeWindow(QQuickWindow* window);
private:
    QMap<quint64, QQuickWindow*> _windows;
    QQmlEngine *_engine;
    QTranslator* _translator = nullptr;
};

#endif // FLUAPP_H
