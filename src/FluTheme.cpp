#include "FluTheme.h"

#include <QGuiApplication>
#if (QT_VERSION >= QT_VERSION_CHECK(6, 5, 0))
#include <QStyleHints>
#elif ((QT_VERSION >= QT_VERSION_CHECK(6, 2, 1)))
#include <QtGui/qpa/qplatformtheme.h>
#include <QtGui/private/qguiapplication_p.h>
#else
#include <QPalette>
#endif
#include "Def.h"
#include "FluColors.h"

FluTheme::FluTheme(QObject *parent):QObject{parent}{
    connect(this,&FluTheme::darkModeChanged,this,[=]{
        Q_EMIT darkChanged();
    });
    primaryColor(FluColors::getInstance()->Blue());
    nativeText(false);
    enableAnimation(true);
    darkMode(FluThemeType::DarkMode::Light);
    _systemDark = systemDark();
    qApp->installEventFilter(this);
}

bool FluTheme::eventFilter(QObject *obj, QEvent *event){
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

bool FluTheme::systemDark(){
#if (QT_VERSION >= QT_VERSION_CHECK(6, 5, 0))
    return (QGuiApplication::styleHints()->colorScheme() == Qt::ColorScheme::Dark);
#elif ((QT_VERSION >= QT_VERSION_CHECK(6, 2, 1)))
    if (const QPlatformTheme * const theme = QGuiApplicationPrivate::platformTheme()) {
        return (theme->appearance() == QPlatformTheme::Appearance::Dark);
    }
    return false;
#else
    QPalette palette = qApp->palette();
    QColor color = palette.color(QPalette::Window).rgb();
    return !(color.red() * 0.2126 + color.green() * 0.7152 + color.blue() * 0.0722 > 255 / 2);
#endif
}

bool FluTheme::dark(){
    if(_darkMode == FluThemeType::DarkMode::Dark){
        return true;
    }else if(_darkMode == FluThemeType::DarkMode::Light){
        return false;
    }else if(_darkMode == FluThemeType::DarkMode::System){
        return _systemDark;
    }else{
        return false;
    }
}
