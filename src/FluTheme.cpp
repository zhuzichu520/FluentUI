#include "FluTheme.h"

#include "FluColors.h"
#ifdef Q_OS_WIN
#include <QSettings>
#else
#include <QPalette>
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
    primaryColor(FluColors::getInstance()->Blue());
    textSize(13);
    nativeText(false);
    frameless(true);
    if (follow_system()){dark(isDark());}
    (qobject_cast<QGuiApplication *>(QCoreApplication::instance()))->installEventFilter(this);
}

bool FluTheme::eventFilter(QObject *obj, QEvent *event)
{
    Q_UNUSED(obj);
    if (event->type() == QEvent::ApplicationPaletteChange)
    {
        if (follow_system()){dark(isDark());}
        event->accept();
        return true;
    }
    return false;
}

bool FluTheme::isDark()
{
#ifdef Q_OS_WIN
    QSettings settings("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",QSettings::NativeFormat);
    return !settings.value("AppsUseLightTheme").toBool();
#else
    QPalette palette = (qobject_cast<QGuiApplication *>(QCoreApplication::instance()))->palette();
    return palette.color(QPalette::WindowText).lightness()
            > palette.color(QPalette::Window).lightness();
#endif
}
