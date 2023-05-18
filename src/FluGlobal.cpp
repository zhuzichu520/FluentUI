#include "FluGlobal.h"

#include<QDebug>
#include <FramelessHelper/Quick/framelessquickmodule.h>
#include <FramelessHelper/Core/private/framelessconfig_p.h>

FRAMELESSHELPER_USE_NAMESPACE;

namespace  FluentUI {

void preInit(){
    qDebug()<<"preInit";
    FramelessHelper::Quick::initialize();
    //将样式设置为Basic，不然会导致组件显示异常
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
}
void postInit(){
    qDebug()<<"postInit";
    FramelessHelper::Core::setApplicationOSThemeAware();
    FramelessConfig::instance()->set(Global::Option::EnableBlurBehindWindow);
    FramelessConfig::instance()->set(Global::Option::DisableLazyInitializationForMicaMaterial);
}
void initEngine(QQmlApplicationEngine* engine){
    qDebug()<<"initEngine";
    FramelessHelper::Quick::registerTypes(engine);
    qDebug()<<"FramelessHelper::Quick::registerTypes(engine)";
}

}
