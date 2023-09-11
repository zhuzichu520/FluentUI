#include "FluEventBus.h"

FluEventBus* FluEventBus::m_instance = nullptr;

FluEvent::FluEvent(QObject *parent)
    : QObject{parent}
{

}

FluEventBus *FluEventBus::getInstance()
{
    if(FluEventBus::m_instance == nullptr){
        FluEventBus::m_instance = new FluEventBus;
    }
    return FluEventBus::m_instance;
}

FluEventBus::FluEventBus(QObject *parent)
    : QObject{parent}
{

}

void FluEventBus::registerEvent(FluEvent* event){
    eventData.append(event);
}


void FluEventBus::unRegisterEvent(FluEvent* event){
    eventData.removeOne(event);
}

void FluEventBus::post(const QString& name,const QMap<QString, QVariant>& data){
    foreach (auto event, eventData) {
        if(event->name()==name){
            Q_EMIT event->triggered(data);
        }
    }
}
