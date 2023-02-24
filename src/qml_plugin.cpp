#include "qml_plugin.h"

void FluentUIQmlPlugin::registerTypes(const char *uri)
{
    int major = 1;
    int minor = 0;
    qmlRegisterType<FluentUI>(uri, major, minor, "FluentUI");
    qmlRegisterType(QUrl("qrc:/com.zzc/controls/StandardButton.qml"),uri,major,minor,"StandardButton");
    qmlRegisterType(QUrl("qrc:/com.zzc/controls/FilledButton.qml"),uri,major,minor,"FilledButton");
}

void FluentUIQmlPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{

}

