#ifndef FLUAPP_H
#define FLUAPP_H

#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QJsonArray>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include "FluTheme.h"
#include "FluColors.h"
#include "NativeEventFilter.h"
#include "FluRegister.h"
#include "stdafx.h"

class FluApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,initialRoute);
    Q_PROPERTY_AUTO(QJsonObject,routes);
    QML_NAMED_ELEMENT(FluApp)
    QML_SINGLETON
public:
    static FluApp *getInstance();
    explicit FluApp(QObject *parent = nullptr);
    ~FluApp(){
        if (nativeEvent != Q_NULLPTR) {
            delete nativeEvent;
            nativeEvent = Q_NULLPTR;
        }
    }
    Q_INVOKABLE void run();
    Q_INVOKABLE void navigate(const QString& route,const QJsonObject& argument  = {},FluRegister* fluRegister = nullptr);
    Q_INVOKABLE void init(QQuickWindow *window);
    Q_INVOKABLE QJsonArray awesomelist(const QString& keyword = "");
    Q_INVOKABLE void clipText(const QString& text);
    Q_INVOKABLE QString uuid();
    Q_INVOKABLE void closeApp();
    Q_INVOKABLE void setFluApp(FluApp* val);
    Q_INVOKABLE void setFluTheme(FluTheme* val);
    Q_INVOKABLE void setFluColors(FluColors* val);
public:
    QMap<quint64, QQuickWindow*> wnds;
    static FluApp* fluApp;
    static FluTheme* fluTheme;
    static FluColors* flutColors;
private:
    NativeEventFilter *nativeEvent = Q_NULLPTR;
    QWindow *appWindow;
};

#endif // FLUAPP_H
