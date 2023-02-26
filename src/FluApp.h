#ifndef FLUAPP_H
#define FLUAPP_H

#include <QObject>
#include <QWindow>
#include <QJsonObject>
#include "stdafx.h"

class FluApp : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,initialRoute);
    Q_PROPERTY_AUTO(QJsonObject,routes);
public:

    static FluApp *getInstance();

    Q_INVOKABLE void run();

    Q_INVOKABLE void navigate(const QString& route);

    Q_INVOKABLE void setAppWindow(QWindow *window);

private:
    static FluApp* m_instance;
    QWindow *appWindow;

};

#endif // FLUAPP_H
