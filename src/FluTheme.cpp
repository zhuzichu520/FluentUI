#include "FluTheme.h"

#include "FluColors.h"

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
    isFrameless(false);
    isDark(false);
}
