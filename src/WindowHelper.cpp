#include "WindowHelper.h"

WindowHelper::WindowHelper(QObject *parent)
    : QObject{parent}
{

}

void WindowHelper::setTitle(const QString& text){
    window->setTitle(text);
}

QJsonObject WindowHelper::initWindow(FramelessView* window){
    this->window = window;
    return window->property("argument").toJsonObject();
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
void WindowHelper::updateWindow(){
    this->window->setFlag(Qt::Window,false);
    this->window->setFlag(Qt::Window,true);
}

void WindowHelper::setModality(int type){
    if(type == 0){
        this->window->setModality(Qt::NonModal);
    }else if(type == 1){
        this->window->setModality(Qt::WindowModal);
    }else if(type == 2){
        this->window->setModality(Qt::ApplicationModal);
    }else{
        this->window->setModality(Qt::NonModal);
    }
}
