#include "FluEventBus.h"

FluEvent::FluEvent(QObject *parent):QObject{parent}{
}

FluEventBus::FluEventBus(QObject *parent):QObject{parent}{
}

void FluEventBus::registerEvent(FluEvent* event){
    _eventData.append(event);
}

void FluEventBus::unRegisterEvent(FluEvent* event){
    _eventData.removeOne(event);
}

void FluEventBus::post(const QString& name,const QMap<QString, QVariant>& data){
    foreach (auto event, _eventData) {
        if(event->name()==name){
            Q_EMIT event->triggered(data);
        }
    }
}
