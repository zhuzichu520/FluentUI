#include "fluentuiplugin.h"

#include "FluentUI.h"

FluentUIPlugin::FluentUIPlugin() = default;

void FluentUIPlugin::registerTypes(const char *uri) {
    FluentUI::registerTypes(uri);
}

void FluentUIPlugin::initializeEngine(QQmlEngine *engine, const char *uri) {
    FluentUI::initializeEngine(engine, uri);
}
