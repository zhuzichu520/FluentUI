#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include <QTimer>
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
    isFps(true);
}



void FluApp::setAppWindow(QWindow *window){
    appWindow = window;
}

void FluApp::run(){
    navigate(initialRoute());
}

void FluApp::navigate(const QString& route){
    if(!routes().contains(route)){
        qErrnoWarning("没有找到当前路由");
        return;
    }
    bool isAppWindow = route==initialRoute();
    FramelessView *view = new FramelessView();
    view->setColor(isDark() ? QColor(0,0,0,1) : QColor(255, 255, 255, 1));
    QObject::connect(view, &QQuickView::statusChanged, view, [&](QQuickView::Status status) {
        if (status == QQuickView::Status::Ready) {
            Q_EMIT windowReady(view);

            view->moveToScreenCenter();
            view->show();
        }
    });
    view->setSource((routes().value(route).toString()));
    if(isAppWindow){
        QObject::connect(view->engine(), &QQmlEngine::quit, qApp, &QCoreApplication::quit);
        QObject::connect(qApp, &QGuiApplication::aboutToQuit, qApp, [&view](){view->setSource({});});
    }else{
        view->closeDeleteLater();
    }
}

bool FluApp::equalsWindow(FramelessView *view,QWindow *window){
    return view->winId() == window->winId();
}
