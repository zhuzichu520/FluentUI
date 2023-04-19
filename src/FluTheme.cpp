#include "FluTheme.h"

#include "FluColors.h"
#include <QPalette>
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
    QPalette palette = (qobject_cast<QGuiApplication *>(QCoreApplication::instance()))->palette();
    QColor color = palette.color(QPalette::Window).rgb();
    return !(color.red() * 0.2126 + color.green() * 0.7152 + color.blue() * 0.0722 > 255 / 2);
}
