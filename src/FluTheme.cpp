#include "FluTheme.h"

#include "Def.h"
#include "FluColors.h"
#if (QT_VERSION >= QT_VERSION_CHECK(6, 5, 0))
#include <QStyleHints>
#elif ((QT_VERSION >= QT_VERSION_CHECK(6, 2, 1)))
#include <QPalette>
#include <QtGui/qpa/qplatformtheme.h>
#include <QtGui/private/qguiapplication_p.h>
#endif

#include <QGuiApplication>

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
#if (QT_VERSION >= QT_VERSION_CHECK(6, 5, 0))
    return (QGuiApplication::styleHints()->colorScheme() == Qt::ColorScheme::Dark);
#elif ((QT_VERSION >= QT_VERSION_CHECK(6, 2, 1)))
    if (const QPlatformTheme * const theme = QGuiApplicationPrivate::platformTheme()) {
        return (theme->appearance() == QPlatformTheme::Appearance::Dark);
    }
    return false;
#endif
    return false;
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
