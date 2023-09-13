#include "WindowHelper.h"

#include "FluRegister.h"

WindowHelper::WindowHelper(QObject *parent):QObject{parent}{
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
