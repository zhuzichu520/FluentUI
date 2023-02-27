#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include "FramelessView.h"


FluApp* FluApp::m_instance = nullptr;

FluApp *FluApp::getInstance()
{
    if(FluApp::m_instance == nullptr){
        FluApp::m_instance = new FluApp;
    }
    return FluApp::m_instance;
}

FluApp::FluApp(QObject *parent)
    : QObject{parent}
{
    isDark(true);
}



void FluApp::setAppWindow(QWindow *window){
    appWindow = window;
}

void FluApp::run(){
    if(!routes().contains(initialRoute())){
        qErrnoWarning("没有找到当前路由");
        return;
    }
    FramelessView *view = new FramelessView();
    view->engine()->rootContext()->setContextProperty("FluApp",FluApp::getInstance());
    view->setColor(QColor(255,0,0,1));
    const QUrl url(routes().value(initialRoute()).toString());
    QObject::connect(view, &QQuickView::statusChanged, view, [&](QQuickView::Status status) {
        if (status == QQuickView::Status::Ready) {

                qDebug()<<"-----------winId:"<<view->winId();
        }
    });
    QObject::connect(view->engine(), &QQmlEngine::quit, qApp, &QCoreApplication::quit);
    QObject::connect(qApp, &QGuiApplication::aboutToQuit, qApp, [&view](){view->setSource({});});
//    view->setTitle("FluentUI");
    view->setSource(url);
    view->moveToScreenCenter();
    view->show();
}

void FluApp::navigate(const QString& route){
    if(!routes().contains(route)){
        qErrnoWarning("没有找到当前路由");
        return;
    }
    FramelessView *view = new FramelessView();
    view->engine()->rootContext()->setContextProperty("FluApp",FluApp::getInstance());
    view->setColor(isDark() ? QColor(0,0,0,1) : QColor(255, 255, 255, 1));
    view->setSource((routes().value(route).toString()));
    view->closeDeleteLater();
    view->moveToScreenCenter();
    view->show();
}

void FluApp::getWIdByWindow(QWindow *window){
    qDebug()<< window->winId();
    window->winId();
}
