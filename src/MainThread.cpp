#include "MainThread.h"
#include <QGuiApplication>
#include <QMetaMethod>

std::shared_ptr<MainThread> MainThread::createShared(QObject* bindObject){
    return std::shared_ptr<MainThread>(new MainThread(bindObject), [=](QObject* mainThread) {
        mainThread->deleteLater();
    });
}

MainThread::MainThread(QObject* bindObject): _bindObject(bindObject), _ignoreNullObject(bindObject == nullptr){
    qRegisterMetaType<std::function<void()>>("std::function<void()>");
    auto mainUIThread = qApp->thread();
    if (this->thread() != mainUIThread)
    {
        this->moveToThread(mainUIThread);
    }
}

MainThread::~MainThread(){
}

void MainThread::post(std::function<void()> func){
    QMetaObject::invokeMethod(createShared().get(), "mainThreadSlot", Q_ARG(std::function<void()>, func));
}

void MainThread::mainThreadSlot(std::function<void()> func){
    if ((_ignoreNullObject || _bindObject) && func)
    {
        func();
    }
}
