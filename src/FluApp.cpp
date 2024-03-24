#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QFontDatabase>
#include <QClipboard>
#include <QTranslator>

FluWindowRegister::FluWindowRegister(QObject *parent):QObject{parent}{
    from(nullptr);
    to(nullptr);
    path("");
}

void FluWindowRegister::launch(const QJsonObject& argument){
    FluApp::getInstance()->navigate(path(),argument,this);
}

void FluWindowRegister::onResult(const QJsonObject& data){
    Q_EMIT result(data);
}

FluApp::FluApp(QObject *parent):QObject{parent}{
    useSystemAppBar(false);
}

FluApp::~FluApp(){
}

void FluApp::init(QObject *target,QLocale locale){
    _locale = locale;
    _engine = qmlEngine(target);
    _translator = new QTranslator(this);
    qApp->installTranslator(_translator);
    const QStringList uiLanguages = _locale.uiLanguages();
    for (const QString &name : uiLanguages) {
        const QString baseName = "fluentui_" + QLocale(name).name();
        if (_translator->load(":/qt/qml/FluentUI/i18n/"+ baseName)) {
            _engine->retranslate();
            break;
        }
    }
}

void FluApp::run(){
    navigate(initialRoute());
}

void FluApp::navigate(const QString& route,const QJsonObject& argument,FluWindowRegister* windowRegister){
    if(!routes().contains(route)){
        qCritical()<<"Not Found Route "<<route;
        return;
    }
    QQmlComponent component(_engine, routes().value(route).toString());
    if (component.isError()) {
        qCritical() << component.errors();
        return;
    }
    QVariantMap properties;
    properties.insert("_route",route);
    if(windowRegister){
        properties.insert("_windowRegister",QVariant::fromValue(windowRegister));
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
            win->setProperty("",argument);
            win->show();
            win->raise();
            win->requestActivate();
            return;
        }else if(launchMode == 2){
            win->close();
        }
    }
    win = qobject_cast<QQuickWindow*>(component.createWithInitialProperties(properties));
    if(windowRegister){
        windowRegister->to(win);
    }
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

QVariant FluApp::createWindowRegister(QQuickWindow* window,const QString& path){
    FluWindowRegister *p = new FluWindowRegister(window);
    p->from(window);
    p->path(path);
    return  QVariant::fromValue(p);
}
