#include "fluentuiplugin.h"

#include "FluentUI.h"

FluentUIPlugin::FluentUIPlugin()
{

}

void FluentUIPlugin::registerTypes(const char *uri)
{
    FluentUI::getInstance()->registerTypes(uri);
}

void FluentUIPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri)
    FluentUI::getInstance()->initializeEngine(engine,uri);
}
