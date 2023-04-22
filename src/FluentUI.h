#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QQmlEngine>

class Q_DECL_EXPORT FluentUI
{

public:
    static void registerTypes(const char *uri) ;
    static void initializeEngine(QQmlEngine *engine, const char *uri);
    static void initialize(QQmlEngine *engine);
};

#endif // FLUENTUI_H
