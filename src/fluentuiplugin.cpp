#include "fluentuiplugin.h"
#include <QtQml/QQmlExtensionPlugin>
#include <QGuiApplication>
#include <qdebug.h>
#include "WindowHelper.h"
#include "Def.h"
#include "FluApp.h"
#include "FluColors.h"
#include "FluTheme.h"
#include "FluTools.h"
#include "FluTextStyle.h"
int major = 1;
int minor = 0;
void FluentUIPlugin::registerTypes(const char *uri)
{
    qmlRegisterSingletonType(uri,major,minor, "FluApp", &FluApp::create);
    qmlRegisterSingletonType(uri,major,minor, "FluColors", &FluColors::create);
    qmlRegisterSingletonType(uri,major,minor, "FluTheme", &FluTheme::create);
    qmlRegisterSingletonType(uri,major,minor, "FluTools", &FluTools::create);
    qmlRegisterSingletonType(uri,major,minor, "FluTextStyle", &FluTextStyle::create);
    qmlRegisterType<WindowHelper>(uri,major,minor,"WindowHelper");
    qmlRegisterType<FluColorSet>(uri,major,minor,"FluColorSet");
    qmlRegisterUncreatableMetaObject(Fluent_Awesome::staticMetaObject,  uri,major,minor,"FluentIcons", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(Fluent_DarkMode::staticMetaObject,  uri,major,minor,"FluDarkMode", "Access to enums & flags only");
}

void FluentUIPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
#ifdef Q_OS_WIN
    QFont font;
    font.setFamily("Microsoft YaHei");
    QGuiApplication::setFont(font);
#endif
}
