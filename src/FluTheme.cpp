//#include "FluTheme.h"

//#include "Def.h"
//#include "FluColors.h"
//#include <QPalette>
//#include <QtGui/qpa/qplatformtheme.h>
//#include <QtGui/private/qguiapplication_p.h>
//#include <QGuiApplication>
//#include <FramelessHelper/Core/utils.h>
//#include <FramelessHelper/Core/framelessmanager.h>

//FRAMELESSHELPER_USE_NAMESPACE;

//FluTheme* FluTheme::m_instance = nullptr;

//FluTheme *FluTheme::getInstance()
//{
//    if(FluTheme::m_instance == nullptr){
//        FluTheme::m_instance = new FluTheme;
//    }
//    return FluTheme::m_instance;
//}

//FluTheme::FluTheme(QObject *parent)
//    : QObject{parent}
//{
//    primaryColor(FluColors::getInstance()->Blue());
//    nativeText(false);
//    dark(FramelessManager::instance()->systemTheme() == Global::SystemTheme::Dark);
//    connect(FramelessManager::instance(), &FramelessManager::systemThemeChanged, this, [this](){
//        dark(Utils::getSystemTheme()==Global::SystemTheme::Dark);
//    });
//}

#include "FluTheme.h"

#include "Def.h"
#include "FluColors.h"
#include <QPalette>
#include <QtGui/qpa/qplatformtheme.h>
#include <QtGui/private/qguiapplication_p.h>
#include <QGuiApplication>
#include <FramelessHelper/Core/utils.h>
#include <FramelessHelper/Core/framelessmanager.h>

FRAMELESSHELPER_USE_NAMESPACE;


FluTheme* FluTheme::m_instance = nullptr;

FluTheme *FluTheme::getInstance()
{
    if(FluTheme::m_instance == nullptr){
        FluTheme::m_instance = new FluTheme;
    }
    return FluTheme::m_instance;
}

FluTheme::FluTheme(QObject *parent)
    : QObject{parent}
{
    connect(this,&FluTheme::darkModeChanged,this,[=]{
        Q_EMIT darkChanged();
    });
    primaryColor(FluColors::getInstance()->Blue());
    nativeText(false);
    darkMode(Fluent_DarkMode::Fluent_DarkModeType::Light);
    _systemDark = systemDark();
    qApp->installEventFilter(this);
}

bool FluTheme::eventFilter(QObject *obj, QEvent *event)
{
    Q_UNUSED(obj);
    if (event->type() == QEvent::ApplicationPaletteChange || event->type() == QEvent::ThemeChange)
    {
        _systemDark = systemDark();
        Q_EMIT darkChanged();
        event->accept();
        return true;
    }
    return false;
}


bool FluTheme::systemDark()
{
    return Utils::getSystemTheme()==Global::SystemTheme::Dark;
}

bool FluTheme::dark(){
    if(_darkMode == Fluent_DarkMode::Fluent_DarkModeType::Dark){
        return true;
    }else if(_darkMode == Fluent_DarkMode::Fluent_DarkModeType::Light){
        return false;
    }else if(_darkMode == Fluent_DarkMode::Fluent_DarkModeType::System){
        return _systemDark;
    }else{
        return false;
    }
}
