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

void WindowHelper::setMinimumWidth(int width){
    this->window->setMinimumWidth(width);
}
void WindowHelper::setMaximumWidth(int width){
    this->window->setMaximumWidth(width);
}
void WindowHelper::setMinimumHeight(int height){
    this->window->setMinimumHeight(height);
}
void WindowHelper::setMaximumHeight(int height){
    this->window->setMaximumHeight(height);
}
