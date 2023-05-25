#include <QtQml/QQmlEngineExtensionPlugin>
#include <qdebug.h>
#include <QJSEngine>
#include <QQmlEngine>
#include <QJSValue>
#include <QGuiApplication>
#include <QFontDatabase>
#include "FluApp.h"
#include "FluColors.h"
#include "FluTheme.h"
#include "FluTools.h"

//![plugin]
class FluentUIPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

public:
    void initializeEngine(QQmlEngine *engine, const char *uri) override{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
#ifdef Q_OS_WIN
        QFont font;
        font.setFamily("Microsoft YaHei");
        QGuiApplication::setFont(font);
#endif
        qmlRegisterSingletonType("FluentGlobal", 1, 0, "FluApp", &FluApp::create);
        qmlRegisterSingletonType("FluentGlobal", 1, 0, "FluColors", &FluColors::create);
        qmlRegisterSingletonType("FluentGlobal", 1, 0, "FluTheme", &FluTheme::create);
        qmlRegisterSingletonType("FluentGlobal", 1, 0, "FluTools", &FluTools::create);
    }
};
//![plugin]

#include "fluentuiplugin.moc"
