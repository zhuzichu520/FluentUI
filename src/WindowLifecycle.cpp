#include "WindowLifecycle.h"

#include "FluApp.h"
#include "FluRegister.h"

WindowLifecycle::WindowLifecycle(QObject *parent):QObject{parent}{

}

void WindowLifecycle::onCompleted(QQuickWindow* window){
    this->_window = window;
    FluApp::getInstance()->addWindow(this->_window);
}

void WindowLifecycle::onDestoryOnClose(){
    if(_window){
        FluApp::getInstance()->removeWindow(this->_window);
        _window = nullptr;
    }
}

void WindowLifecycle::onDestruction(){
}

void WindowLifecycle::onVisible(bool visible){
}

QVariant WindowLifecycle::createRegister(QQuickWindow* window,const QString& path){
    FluRegister *p = new FluRegister(window);
    p->from(window);
    p->path(path);
    return  QVariant::fromValue(p);
}
