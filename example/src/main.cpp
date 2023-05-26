#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QProcess>
#include "AppInfo.h"

int main(int argc, char *argv[])
{
#if (QT_VERSION < QT_VERSION_CHECK(6, 0, 0))
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
#endif
#endif
    //将样式设置为Basic，不然会导致组件显示异常
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
    QGuiApplication::setOrganizationName("ZhuZiChu");
    QGuiApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QGuiApplication::setApplicationName("FluentUI");
    QGuiApplication app(argc, argv);
    AppInfo* appInfo = new AppInfo();
    IPC ipc(0);
    if(!appInfo->isOwnerProcess(&ipc)){
        return 0;
    }
    app.setQuitOnLastWindowClosed(false);
    QQmlApplicationEngine engine;
    appInfo->init(&engine);
    const QUrl url(QStringLiteral("qrc:/example/qml/App.qml"));
    //    const QUrl url(QStringLiteral("qrc:/example/qml/TestWindow.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
