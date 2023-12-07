#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QFontDatabase>
#include <QClipboard>
#include <FramelessHelper/Quick/framelessquickmodule.h>
#include <FramelessHelper/Core/private/framelessconfig_p.h>

FRAMELESSHELPER_USE_NAMESPACE

FluApp::FluApp(QObject *parent):QObject{parent}{
    vsync(true);
    useSystemAppBar(false);
    connect(this,&FluApp::useSystemAppBarChanged,this,[=]{FramelessConfig::instance()->set(Global::Option::UseSystemAppBar,_useSystemAppBar);});
}

FluApp::~FluApp(){
}

void FluApp::init(QObject *application){
    this->_application = application;
    FramelessHelperQuickInitialize();
    FramelessConfig::instance()->set(Global::Option::DisableLazyInitializationForMicaMaterial);
    FramelessConfig::instance()->set(Global::Option::CenterWindowBeforeShow);
    QQmlEngine *engine = qmlEngine(_application);
    FramelessHelper::Quick::registerTypes(engine);
    QJSEngine * jsEngine = qjsEngine(_application);
    std::string jsFunction = R"( (function () { console.log("FluentUI");}) )";
    QJSValue function = jsEngine->evaluate(QString::fromStdString(jsFunction));
    jsEngine->globalObject().setProperty("__fluentui",function);
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
        pair.second->close();
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
