#include "fluentuiplugin.h"

#include "FluentUI.h"

FluentUIPlugin::FluentUIPlugin() = default;

void FluentUIPlugin::registerTypes(const char *uri) {
    FluentUI::getInstance()->registerTypes(uri);
}

void FluentUIPlugin::initializeEngine(QQmlEngine *engine, const char *uri) {
    FluentUI::getInstance()->initializeEngine(engine, uri);
}
