#ifndef FLUAPP_H
#define FLUAPP_H

#include <QObject>
#include <QWindow>
#include <QJsonArray>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include "FluRegister.h"
#include "FramelessView.h"
#include "stdafx.h"

class FluApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,initialRoute);
    Q_PROPERTY_AUTO(QJsonObject,routes);

public:

    static FluApp *getInstance();

    explicit FluApp(QObject *parent = nullptr);

    Q_INVOKABLE void run();

    Q_INVOKABLE void navigate(const QString& route,const QJsonObject& argument  = {},FluRegister* fluRegister = nullptr);

    Q_INVOKABLE void init(QWindow *window,QMap<QString, QVariant> properties);

    Q_SIGNAL void windowReady(FramelessView *view);

    Q_INVOKABLE bool equalsWindow(FramelessView *view,QWindow *window);

    Q_INVOKABLE QJsonArray awesomelist(const QString& keyword = "");

    Q_INVOKABLE void clipText(const QString& text);

private:
    QMap<QString, QVariant> properties;
    static FluApp* m_instance;
    QWindow *appWindow;

};

#endif // FLUAPP_H
