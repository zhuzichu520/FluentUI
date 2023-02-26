#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "TaoFrameLessView.h"

#if defined(STATICLIB)
#include <FluentUI.h>
#endif


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
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



//    TaoFrameLessView view;
//#if defined(STATICLIB)
//    FluentUI::create(view.engine());
//#endif
//    const QUrl url(QStringLiteral("qrc:/main.qml"));
//    QObject::connect(&view, &QQuickView::statusChanged, &view, [&](QQuickView::Status status) {
//        if (status == QQuickView::Status::Ready) {

//        }
//    });
//    //qml call 'Qt.quit()' will emit engine::quit, here should call qApp->quit
//    QObject::connect(view.engine(), &QQmlEngine::quit, qApp, &QCoreApplication::quit);
//    //qml clear content before quit
//    QObject::connect(qApp, &QGuiApplication::aboutToQuit, qApp, [&view](){view.setSource({});});

//    view.setSource(url);
//    view.moveToScreenCenter();
//    view.show();

    return app.exec();
}
