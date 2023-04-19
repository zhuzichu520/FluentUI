#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QProcess>
#include "lang/Lang.h"
#include "AppInfo.h"
#include "ChatController.h"

int main(int argc, char *argv[])
{
    //将样式设置为Basic，不然会导致组件显示异常
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
    //6.4及以下监听系统深色模式变化
    qputenv("QT_QPA_PLATFORM","windows:darkmode=2");
    QCoreApplication::setOrganizationName("ZhuZiChu");
    QCoreApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QCoreApplication::setApplicationName("FluentUI");
//    QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);
    QGuiApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(false);
    QQmlApplicationEngine engine;
    qmlRegisterType<ChatController>("Controller",1,0,"ChatController");
    AppInfo* appInfo = new AppInfo();
    QQmlContext * context = engine.rootContext();
    Lang* lang = appInfo->lang();
    context->setContextProperty("lang",lang);
    QObject::connect(appInfo,&AppInfo::langChanged,&app,[context,appInfo]{
        context->setContextProperty("lang",appInfo->lang());
    });
    context->setContextProperty("appInfo",appInfo);
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
