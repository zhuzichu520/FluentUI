#include "WindowLifecycle.h"

#include "FluApp.h"
#include "FluRegister.h"

WindowLifecycle::WindowLifecycle(QObject *parent):QObject{parent}{
}

void WindowLifecycle::onCompleted(QQuickWindow* window){
    this->_window = window;
    vsyncEnable(FluApp::getInstance()->vsync());
    FluApp::getInstance()->addWindow(this->_window);
}

void WindowLifecycle::onDestoryOnClose(){
    FluApp::getInstance()->removeWindow(this->_window);
}

void WindowLifecycle::onDestruction(){
}

void WindowLifecycle::onVisible(bool visible){
}

void WindowLifecycle::vsyncEnable(bool enable){
    auto froamt = _window->format();
    froamt.setSwapInterval(enable);
    _window->setFormat(froamt);
}

QVariant WindowLifecycle::createRegister(QQuickWindow* window,const QString& path){
    FluRegister *p = new FluRegister(window);
    p->from(window);
    p->path(path);
    return  QVariant::fromValue(p);
}
