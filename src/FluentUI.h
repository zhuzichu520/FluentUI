#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>

class Q_DECL_EXPORT FluentUI
{

public:
    static void preInit();
    static void postInit();
    static void initEngine(QQmlApplicationEngine *engine);
};

#endif // FLUENTUI_H
