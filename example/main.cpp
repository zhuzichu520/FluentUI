#include <QGuiApplication>
#include <QQmlApplicationEngine>

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
    return app.exec();
}
