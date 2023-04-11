#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QQuickStyle>
#include <QProcess>
#include "AppInfo.h"
#include "ChatController.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("ZhuZiChu");
    QCoreApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QCoreApplication::setApplicationName("FluentUI");
    QQuickStyle::setStyle("Basic");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    qmlRegisterType<ChatController>("Controller",1,0,"ChatController");
    engine.rootContext()->setContextProperty("appInfo",new AppInfo());
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
