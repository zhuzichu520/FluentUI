#include "FluentUI.h"
#include <FramelessHelper/Quick/framelessquickmodule.h>
#include <FramelessHelper/Core/private/framelessconfig_p.h>

FRAMELESSHELPER_USE_NAMESPACE;

void FluentUI::preInit(){
    qDebug()<<"FluentUI init";
    FramelessHelper::Quick::initialize();
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
    //6.4及以下监听系统深色模式变化
#ifdef Q_OS_WIN
    qputenv("QT_QPA_PLATFORM","windows:darkmode=2");
#endif
}

void FluentUI::postInit(){
    FramelessHelper::Core::setApplicationOSThemeAware();
    FramelessConfig::instance()->set(Global::Option::EnableBlurBehindWindow);
    FramelessConfig::instance()->set(Global::Option::DisableLazyInitializationForMicaMaterial);
}
