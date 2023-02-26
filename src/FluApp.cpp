#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include "FramelessView.h"


FluApp* FluApp::m_instance = nullptr;

FluApp *FluApp::getInstance()
{
    if(FluApp::m_instance == nullptr){
        FluApp::m_instance = new FluApp;
    }
    return FluApp::m_instance;
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
    const QUrl url(routes().value(initialRoute()).toString());
    QObject::connect(view, &QQuickView::statusChanged, view, [&](QQuickView::Status status) {
        if (status == QQuickView::Status::Ready) {

        }
    });
    QObject::connect(view->engine(), &QQmlEngine::quit, qApp, &QCoreApplication::quit);
    QObject::connect(qApp, &QGuiApplication::aboutToQuit, qApp, [&view](){view->setSource({});});
    view->setSource(url);
    view->moveToScreenCenter();
    view->show();
}

void FluApp::navigate(const QString& route){
    qDebug()<<"开始路由跳转->"<<route;
    if(!routes().contains(route)){
        qErrnoWarning("没有找到当前路由");
        return;
    }
    FramelessView *view = new FramelessView();
    view->engine()->rootContext()->setContextProperty("FluApp",FluApp::getInstance());
    view->setSource((routes().value(route).toString()));
    view->closeDeleteLater();
    view->moveToScreenCenter();
    view->show();
}
