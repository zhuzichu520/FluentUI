#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QQmlEngine>

class FluentUI
{

public:
    static void registerTypes(const char *uri) ;
    static void initializeEngine(QQmlEngine *engine, const char *uri);
};

#endif // FLUENTUI_H
