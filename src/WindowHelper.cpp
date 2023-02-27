#include "WindowHelper.h"

WindowHelper::WindowHelper(QObject *parent)
    : QObject{parent}
{

}

void WindowHelper::setTitle(const QString& text){
    window->setTitle(text);
}


void WindowHelper::initWindow(FramelessView* window){
    this->window = window;
}
