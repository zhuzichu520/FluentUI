#include "FluWindowLifecycle.h"

#include "FluApp.h"
#include "FluRegister.h"

FluWindowLifecycle::FluWindowLifecycle(QObject *parent):QObject{parent}{

}

void FluWindowLifecycle::onCompleted(QQuickWindow* window){
    this->_window = window;
    FluApp::getInstance()->addWindow(this->_window);
}

void FluWindowLifecycle::onDestoryOnClose(){
    if(_window){
        FluApp::getInstance()->removeWindow(this->_window);
        _window = nullptr;
    }
}

void FluWindowLifecycle::onDestruction(){
}

void FluWindowLifecycle::onVisible(bool visible){
}

QVariant FluWindowLifecycle::createRegister(QQuickWindow* window,const QString& path){
    FluRegister *p = new FluRegister(window);
    p->from(window);
    p->path(path);
    return  QVariant::fromValue(p);
}
