#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <time.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    clock_t start,finish;
    double totaltime;
    start=clock();
    qputenv("QSG_RENDER_LOOP","basic");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    finish=clock();
    totaltime=(double)(finish-start)/CLOCKS_PER_SEC;
    qDebug() << "startup time :" << totaltime << "s";
    return app.exec();
}
