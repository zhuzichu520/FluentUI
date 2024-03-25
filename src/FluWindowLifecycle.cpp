#include "FluWindowLifecycle.h"

#include "FluApp.h"

FluWindowLifecycle::FluWindowLifecycle(QObject *parent):QObject{parent}{

}

void FluWindowLifecycle::onCompleted(QQuickWindow* window){
    _window = window;
    if(_window && _window->transientParent() == nullptr){
        FluApp::getInstance()->addWindow(_window);
    }
}

void FluWindowLifecycle::onDestroyOnClose(){
    if(_window && _window->transientParent() == nullptr){
        FluApp::getInstance()->removeWindow(_window);
        _window = nullptr;
    }
}

void FluWindowLifecycle::onDestruction(){

}

void FluWindowLifecycle::onVisible(bool visible){
}
