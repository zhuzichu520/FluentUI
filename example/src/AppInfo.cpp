#include "AppInfo.h"

#include <QQmlContext>
#include <QDebug>
#include <QGuiApplication>
#include "lang/En.h"
#include "lang/Zh.h"
#include "Version.h"

AppInfo::AppInfo(QObject *parent)
    : QObject{parent}
{
    version(APPLICATION_VERSION);
    lang(new En());
}

void AppInfo::init(QQmlApplicationEngine *engine){
    QQmlContext * context = engine->rootContext();
    Lang* lang = this->lang();
    context->setContextProperty("lang",lang);
    QObject::connect(this,&AppInfo::langChanged,this,[=]{
        context->setContextProperty("lang",this->lang());
    });
}

void AppInfo::changeLang(const QString& locale){
    if(_lang){
        _lang->deleteLater();
    }
    if(locale=="Zh"){
        lang(new Zh());
    }else if(locale=="En"){
        lang(new En());
    }else {
        lang(new En());
    }
}
