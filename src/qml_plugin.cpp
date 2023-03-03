#include "qml_plugin.h"

void FluentUIQmlPlugin::registerTypes(const char *uri)
{
    FluentUI::registerTypes(uri);
}

void FluentUIQmlPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    FluentUI::initializeEngine(engine,uri);
}

