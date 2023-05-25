#include "WindowHelper.h"

#include "FluRegister.h"
#include "FluApp.h"

WindowHelper::WindowHelper(QObject *parent)
    : QObject{parent}
{

}

void WindowHelper::initWindow(QQuickWindow* window){
    this->window = window;
}

QVariant WindowHelper::createRegister(QQuickWindow* window,const QString& path){
    FluRegister *p = new FluRegister(window);
    p->from(window);
    p->path(path);
    return  QVariant::fromValue(p);
}

void WindowHelper::deleteWindow(){
    if(this->window){
        FluApp::getInstance()->wnds.remove(this->window->winId());
        this->window->deleteLater();
    }
}
