#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QFontDatabase>
#include <QClipboard>

FluApp::FluApp(QObject *parent):QObject{parent}{
    httpInterceptor(nullptr);
}

FluApp::~FluApp(){
}

void FluApp::init(QQuickWindow *window){
    this->_application = window;
}

void FluApp::run(){
    navigate(initialRoute());
}

void FluApp::navigate(const QString& route,const QJsonObject& argument,FluRegister* fluRegister){
    if(!routes().contains(route)){
        qCritical()<<"No route found "<<route;
        return;
    }
    QQmlEngine *engine = qmlEngine(_application);
    QQmlComponent component(engine, routes().value(route).toString());
    if (component.isError()) {
        qCritical() << component.errors();
        return;
    }
    QVariantMap properties;
    properties.insert("_route",route);
    if(fluRegister){
        properties.insert("_pageRegister",QVariant::fromValue(fluRegister));
    }
    properties.insert("argument",argument);
    QQuickWindow *win=nullptr;
    for (const auto& pair : _windows.toStdMap()) {
        QString r =  pair.second->property("_route").toString();
        if(r == route){
            win = pair.second;
            break;
        }
    }
    if(win){
        int launchMode = win->property("launchMode").toInt();
        if(launchMode == 1){
            win->setProperty("argument",argument);
            win->show();
            win->raise();
            win->requestActivate();
            return;
        }else if(launchMode == 2){
            win->close();
        }
    }
    win = qobject_cast<QQuickWindow*>(component.createWithInitialProperties(properties));
    if(fluRegister){
        fluRegister->to(win);
    }
    win->setColor(QColor(Qt::transparent));
}

void FluApp::exit(int retCode){
    for (const auto& pair : _windows.toStdMap()) {
        removeWindow(pair.second);
    }
    qApp->exit(retCode);
}

void FluApp::addWindow(QQuickWindow* window){
    _windows.insert(window->winId(),window);
}

void FluApp::removeWindow(QQuickWindow* window){
    if(window){
        _windows.remove(window->winId());
        window->deleteLater();
        window = nullptr;
    }
}
