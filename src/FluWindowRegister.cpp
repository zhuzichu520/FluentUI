#include "FluWindowRegister.h"

#include "FluApp.h"
#include <QCoreApplication>

FluWindowRegister::FluWindowRegister(QObject *parent):QObject{parent}{
    from(nullptr);
    to(nullptr);
    path("");
}

void FluWindowRegister::launch(const QJsonObject& argument){
    FluApp::getInstance()->navigate(path(),argument,this);
}

void FluWindowRegister::onResult(const QJsonObject& data){
    Q_EMIT result(data);
}
