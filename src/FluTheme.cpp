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
    nativeText(true);
    frameless(true);
    std::function<bool()> isDark = [](){
        QPalette palette = (qobject_cast<QGuiApplication *>(QCoreApplication::instance()))->palette();
        QColor color = palette.color(QPalette::Window).rgb();
        return !(color.red() * 0.2126 + color.green() * 0.7152 + color.blue() * 0.0722 > 255 / 2);
    };
    dark(isDark());
    connect(qobject_cast<QGuiApplication *>(QCoreApplication::instance()), &QGuiApplication::paletteChanged, this, [=] (const QPalette &) {
        dark(isDark());
    });
}
