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
#include "FluHttp.h"
#include "FluHttpInterceptor.h"
#include "FluWatermark.h"
#include "FluCaptcha.h"
#include "Screenshot.h"
#include "QRCode.h"

int major = 1;
int minor = 0;
static FluentUIPlugin instance;

FluentUIPlugin::FluentUIPlugin()
{
#ifdef FLUENTUI_BUILD_STATIC_LIB
    Q_INIT_RESOURCE(fluentui);
#endif
}

void FluentUIPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<WindowHelper>(uri,major,minor,"WindowHelper");
    qmlRegisterType<QRCode>(uri,major,minor,"QRCode");
    qmlRegisterType<FluCaptcha>(uri,major,minor,"FluCaptcha");
    qmlRegisterType<FluWatermark>(uri,major,minor,"FluWatermark");
    qmlRegisterType<ScreenshotBackground>(uri,major,minor,"ScreenshotBackground");
    qmlRegisterType<Screenshot>(uri,major,minor,"Screenshot");
    qmlRegisterType<FluColorSet>(uri,major,minor,"FluColorSet");
    qmlRegisterType<FluHttpInterceptor>(uri,major,minor,"FluHttpInterceptor");
    qmlRegisterType<FluHttp>(uri,major,minor,"FluHttp");
    qmlRegisterType<HttpCallable>(uri,major,minor,"HttpCallable");
    qmlRegisterUncreatableMetaObject(Fluent_Awesome::staticMetaObject,  uri,major,minor,"FluentIcons", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluHttpType::staticMetaObject,  uri,major,minor,"FluHttpType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluThemeType::staticMetaObject,  uri,major,minor,"FluThemeType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluPageType::staticMetaObject,  uri,major,minor,"FluPageType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluWindowType::staticMetaObject,  uri,major,minor,"FluWindowType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTreeViewType::staticMetaObject,  uri,major,minor,"FluTreeViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluStatusViewType::staticMetaObject,  uri,major,minor,"FluStatusViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluContentDialogType::staticMetaObject,  uri,major,minor,"FluContentDialogType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTimePickerType::staticMetaObject,  uri,major,minor,"FluTimePickerType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluCalendarViewType::staticMetaObject,  uri,major,minor,"FluCalendarViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTabViewType::staticMetaObject,  uri,major,minor,"FluTabViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluNavigationViewType::staticMetaObject,  uri,major,minor,"FluNavigationViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTimelineType::staticMetaObject,  uri,major,minor,"FluTimelineType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluScreenshotType::staticMetaObject,  uri,major,minor,"FluScreenshotType", "Access to enums & flags only");
}

#ifdef FLUENTUI_BUILD_STATIC_LIB
void FluentUIPlugin::registerTypes()
{
    instance()->registerTypes("FluentUI");
}

FluentUIPlugin* FluentUIPlugin::instance()
{
    static FluentUIPlugin instance;
    return &instance;
}
#endif
void FluentUIPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri)
#ifdef Q_OS_WIN
    QFont font;
    font.setFamily("Microsoft YaHei");
    QGuiApplication::setFont(font);
#endif
    FluApp* app = FluApp::getInstance();
    engine->rootContext()->setContextProperty("FluApp",app);
    FluColors* colors = FluColors::getInstance();
    engine->rootContext()->setContextProperty("FluColors",colors);
    FluTheme* theme = FluTheme::getInstance();
    engine->rootContext()->setContextProperty("FluTheme",theme);
    FluTools* tools = FluTools::getInstance();
    engine->rootContext()->setContextProperty("FluTools",tools);
    FluTextStyle* textStyle = FluTextStyle::getInstance();
    engine->rootContext()->setContextProperty("FluTextStyle",textStyle);
    engine->addImportPath("qrc:/FluentUI/imports/");
}
