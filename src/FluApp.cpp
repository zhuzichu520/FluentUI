#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QClipboard>
#include "FluTheme.h"
#include "Def.h"

#ifdef Q_OS_WIN
#pragma comment(lib, "Dwmapi.lib")
#pragma comment(lib, "User32.lib")
#include <dwmapi.h>
#include <Windows.h>
#include <windowsx.h>
static bool isCompositionEnabled()
{
    BOOL composition_enabled = FALSE;
    bool success = ::DwmIsCompositionEnabled(&composition_enabled) == S_OK;
    return composition_enabled && success;
}
#endif

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
}

void FluApp::init(QQuickWindow *window){
    this->appWindow = window;
}

void FluApp::run(){
#ifdef Q_OS_WIN
    if(!isCompositionEnabled()){
        FluTheme::getInstance()->frameless(false);
    }
#endif
    navigate(initialRoute());
}

void FluApp::navigate(const QString& route,const QJsonObject& argument,FluRegister* fluRegister){
    if(!routes().contains(route)){
        qErrnoWarning("没有找到当前路由");
        return;
    }
    QQmlEngine *engine = qmlEngine(appWindow);
    QQmlComponent component(engine, routes().value(route).toString());
    QVariantMap properties;
    properties.insert("route",route);
    if(fluRegister){
        properties.insert("pageRegister",QVariant::fromValue(fluRegister));
    }
    properties.insert("argument",argument);
    QQuickWindow *view = qobject_cast<QQuickWindow*>(component.createWithInitialProperties(properties));

    int launchMode = view->property("launchMode").toInt();
    if(launchMode==1){
        for (auto& pair : wnds) {
            QString r =  pair->property("route").toString();
            if(r == route){
                pair->requestActivate();
                view->deleteLater();
                return;
            }
        }
    }else if(launchMode==2){
        for (auto& pair : wnds) {
            QString r =  pair->property("route").toString();
            if(r == route){
                pair->close();
                break;
            }
        }
    }

    if(FluTheme::getInstance()->frameless()){
        view->setFlag(Qt::FramelessWindowHint,true);
    }
    wnds.insert(view->winId(),view);
    if(fluRegister){
        fluRegister->to(view);
    }
    view->setColor(QColor(Qt::transparent));
    view->show();
}

QJsonArray FluApp::awesomelist(const QString& keyword)
{
    QJsonArray arr;
    QMetaEnum enumType = Fluent_Awesome::staticMetaObject.enumerator(Fluent_Awesome::staticMetaObject.indexOfEnumerator("Fluent_AwesomeType"));
    for(int i=0; i < enumType.keyCount(); ++i){
        QString name = enumType.key(i);
        int icon = enumType.value(i);
        if(keyword.isEmpty()){
            QJsonObject obj;
            obj.insert("name",name);
            obj.insert("icon",icon);
            arr.append(obj);
        }else{
            if(name.contains(keyword)){
                QJsonObject obj;
                obj.insert("name",name);
                obj.insert("icon",icon);
                arr.append(obj);
            }
        }
    }
    return arr;
}

void FluApp::clipText(const QString& text){
    QGuiApplication::clipboard()->setText(text);
}

QString FluApp::uuid(){
    return QUuid::createUuid().toString();
}

void FluApp::closeApp(){
    qApp->exit(0);
}
