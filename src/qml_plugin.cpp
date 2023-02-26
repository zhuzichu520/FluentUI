#include "qml_plugin.h"

#include "Fluent.h"

void FluentUIQmlPlugin::registerTypes(const char *uri)
{
    Fluent::getInstance()->registerTypes(uri);
}

void FluentUIQmlPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Fluent::getInstance()->initializeEngine(engine,uri);
}

