#include "WindowHelper.h"

#include "FluRegister.h"

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

QJsonObject WindowHelper::getArgument(){
    return window->property("argument").toJsonObject();
}

QVariant WindowHelper::getPageRegister(){
    return window->property("pageRegister");
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
void WindowHelper::setOpacity(qreal opacity){
    this->window->setOpacity(opacity);
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

QVariant WindowHelper::createRegister(const QString& path){
    FluRegister *p = new FluRegister(this->window);
    p->from(this->window);
    p->path(path);
    return  QVariant::fromValue(p);
}
