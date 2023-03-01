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

void WindowHelper::setMinimumSize(const QSize &size){
    this->window->setMinimumSize(size);
}
void WindowHelper::setMaximumSize(const QSize &size){
    this->window->setMaximumSize(size);
}
