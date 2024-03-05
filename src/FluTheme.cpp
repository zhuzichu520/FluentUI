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
    connect(this,&FluTheme::darkChanged,this,[=]{refreshColors();});
    connect(this,&FluTheme::themeColorChanged,this,[=]{refreshColors();});
    themeColor(FluColors::getInstance()->Blue());
    darkMode(FluThemeType::DarkMode::Light);
    nativeText(false);
    enableAnimation(true);
    _systemDark = systemDark();
    qApp->installEventFilter(this);
}

void FluTheme::refreshColors(){
    auto isDark = dark();
    primaryColor(isDark ? _themeColor->lighter() : _themeColor->dark());
    backgroundColor(isDark ? QColor(0,0,0,255) : QColor(1,1,1,255));
    dividerColor(isDark ? QColor(80,80,80,255) : QColor(210,210,210,255));
    windowBackgroundColor(isDark ? QColor(32,32,32,255) : QColor(237,237,237,255));
    windowActiveBackgroundColor(isDark ? QColor(26,26,26,255) : QColor(243,243,243,255));
    fontPrimaryColor(isDark ? QColor(248,248,248,255) : QColor(7,7,7,255));
    fontSecondaryColor(isDark ? QColor(222,222,222,255) : QColor(102,102,102,255));
    fontTertiaryColor(isDark ? QColor(200,200,200,255) : QColor(153,153,153,255));
    itemNormalColor(isDark ? QColor(255,255,255,0) : QColor(0,0,0,0));
    itemHoverColor(isDark ? QColor(255,255,255,255*0.03) : QColor(0,0,0,255*0.03));
    itemPressColor(isDark ? QColor(255,255,255,255*0.06) : QColor(0,0,0,255*0.06));
    itemCheckColor(isDark ? QColor(255,255,255,255*0.09) : QColor(0,0,0,255*0.09));
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

QJsonArray FluTheme::awesomeList(const QString& keyword){
    QJsonArray arr;
    QMetaEnum enumType = Fluent_Awesome::staticMetaObject.enumerator(Fluent_Awesome::staticMetaObject.indexOfEnumerator("Fluent_AwesomeType"));
    for(int i=0; i < enumType.keyCount(); ++i){
        QString name = enumType.key(i);
        int icon = enumType.value(i);
        if(keyword.isEmpty() || name.contains(keyword)){
            QJsonObject obj;
            obj.insert("name",name);
            obj.insert("icon",icon);
            arr.append(obj);
        }
    }
    return arr;
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
