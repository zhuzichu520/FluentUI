#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "InstallHelper.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("ZhuZiChu");
    QCoreApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QCoreApplication::setApplicationName("FluentUI");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
       qDebug()<<"setContextProperty------->1";
    engine.rootContext()->setContextProperty("installHelper",new InstallHelper());
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
