#include "AppInfo.h"
#include "lang/En.h"
#include "lang/Zh.h"


AppInfo::AppInfo(QObject *parent)
    : QObject{parent}
{
    version("1.2.7");
    lang(new En());
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
