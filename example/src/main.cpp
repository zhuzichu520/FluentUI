#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QProcess>
#include <FluentUI/FluentUI.h>
#include "lang/Lang.h"
#include "AppInfo.h"
#include "tool/IPC.h"

int main(int argc, char *argv[])
{
    //将样式设置为Basic，不然会导致组件显示异常
    FluentUI::preInit();
    QGuiApplication::setOrganizationName("ZhuZiChu");
    QGuiApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QGuiApplication::setApplicationName("FluentUI");
    //    QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);
    QGuiApplication app(argc, argv);
    FluentUI::postInit();
    AppInfo* appInfo = new AppInfo();
    IPC ipc(0);
    QString activeWindowEvent = "activeWindow";
    if(!ipc.isCurrentOwner()){
        ipc.postEvent(activeWindowEvent,QString().toUtf8(),0);
        delete appInfo;
        return 0;
    }
    if(ipc.isAttached()){
        ipc.registerEventHandler(activeWindowEvent,[&appInfo](const QByteArray&){
            Q_EMIT appInfo->activeWindow();
            return true;
        });
    }
    app.setQuitOnLastWindowClosed(false);
    QQmlApplicationEngine engine;
    FluentUI::initEngine(&engine);
    QQmlContext * context = engine.rootContext();
    Lang* lang = appInfo->lang();
    context->setContextProperty("lang",lang);
    QObject::connect(appInfo,&AppInfo::langChanged,&app,[context,appInfo]{
        context->setContextProperty("lang",appInfo->lang());
    });
    context->setContextProperty("appInfo",appInfo);
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
