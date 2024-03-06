#include "FluWindowLifecycle.h"

#include "FluApp.h"

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
