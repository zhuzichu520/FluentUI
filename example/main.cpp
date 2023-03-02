#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "InstallHelper.h"

#if defined(STATICLIB)
#include <FluentUI.h>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("ZhuZiChu");
    QCoreApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QCoreApplication::setApplicationName("FluentUI");

    qputenv("QSG_RENDER_LOOP","basic");
    QCoreApplication::setAttribute(Qt::AA_DontCreateNativeWidgetSiblings);
#if (QT_VERSION < QT_VERSION_CHECK(6, 0, 0))
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#endif
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::Round);
#endif
    //    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<InstallHelper>("UI",1,0,"InstallHelper");

#if defined(STATICLIB)
    FluentUI::create(&engine);
#endif
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
