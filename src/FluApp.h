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
#include "stdafx.h"

/**
 * @brief The FluApp class
 */
class FluApp : public QObject
{
    Q_OBJECT
    /**
     * @brief initialRoute 初始路由
     */
    Q_PROPERTY_AUTO(QString,initialRoute);

    /**
     * @brief routes 路由表
     */
    Q_PROPERTY_AUTO(QJsonObject,routes);

private:
    /**
     * @brief FluApp 将默认构造函数设置为私有，则qml创建单例就会走create工厂方法创建单例
     * @param parent
     */
    explicit FluApp(QObject *parent = nullptr);
public:
    ~FluApp();
    static QJSValue create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        Q_UNUSED(qmlEngine)
        return jsEngine->newQObject(getInstance());
    }
    static FluApp *getInstance();
    /**
     * @brief run
     */
    Q_INVOKABLE void run();

    /**
     * @brief navigate
     * @param route
     * @param argument
     * @param fluRegister
     */
    Q_INVOKABLE void navigate(const QString& route,const QJsonObject& argument  = {},FluRegister* fluRegister = nullptr);

    /**
     * @brief init
     * @param window
     */
    Q_INVOKABLE void init(QQuickWindow *window);

    /**
     * @brief awesomelist
     * @param keyword
     * @return
     */
    Q_INVOKABLE QJsonArray awesomelist(const QString& keyword = "");

    /**
     * @brief closeApp
     */
    Q_INVOKABLE void closeApp();

public:
    /**
     * @brief wnds
     */
    QMap<quint64, QQuickWindow*> wnds;

private:
    static FluApp* m_instance;
    /**
     * @brief appWindow
     */
    QWindow *appWindow;
};

#endif // FLUAPP_H
