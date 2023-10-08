#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QNetworkProxy>
#include <QSslConfiguration>
#include <QProcess>
#include <QtQml/qqmlextensionplugin.h>
#include <QLoggingCategory>
#include "AppInfo.h"
#include "src/component/CircularReveal.h"
#include "src/component/FileWatcher.h"
#include "src/component/FpsItem.h"
#include "src/helper/SettingsHelper.h"

#ifdef FLUENTUI_BUILD_STATIC_LIB
#if (QT_VERSION > QT_VERSION_CHECK(6, 2, 0))
Q_IMPORT_QML_PLUGIN(FluentUIPlugin)
#endif
#include <FluentUI.h>
#endif

int main(int argc, char *argv[])
{
    QNetworkProxy::setApplicationProxy(QNetworkProxy::NoProxy);
#if (QT_VERSION < QT_VERSION_CHECK(6, 0, 0))
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
#endif
#endif
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
    QGuiApplication::setOrganizationName("ZhuZiChu");
    QGuiApplication::setOrganizationDomain("https://zhuzichu520.github.io");
    QGuiApplication::setApplicationName("FluentUI");
    SettingsHelper::getInstance()->init(argv);
    if(SettingsHelper::getInstance()->getReander()=="software"){
#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
        QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);
#elif (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
        QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Software);
#endif
    }
    QGuiApplication app(argc, argv);
    //    QLoggingCategory::setFilterRules(QStringLiteral("qt.scenegraph.general=true"));
    //    qSetMessagePattern("%{category}: %{message}");
    QQmlApplicationEngine engine;
    AppInfo::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("AppInfo",AppInfo::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper",SettingsHelper::getInstance());
#ifdef FLUENTUI_BUILD_STATIC_LIB
    FluentUI::getInstance()->registerTypes(&engine);
#endif
    qDebug()<<engine.importPathList();
    qmlRegisterType<CircularReveal>("example", 1, 0, "CircularReveal");
    qmlRegisterType<FileWatcher>("example", 1, 0, "FileWatcher");
    qmlRegisterType<FpsItem>("example", 1, 0, "FpsItem");
    const QUrl url(QStringLiteral("qrc:/example/qml/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    const int exec = QGuiApplication::exec();
    if (exec == 931) {
        QProcess::startDetached(qApp->applicationFilePath(), QStringList());
    }
    return exec;
}
