#include "FluRegister.h"

#include "FluApp.h"
#include <QCoreApplication>

FluRegister::FluRegister(QObject *parent)
    : QObject{parent}
{
    from(nullptr);
    to(nullptr);
    path("");
}

void FluRegister::launch(const QJsonObject& argument){
    FluApp::getInstance()->navigate(path(),argument,this);
}

void FluRegister::onResult(const QJsonObject& data){
    Q_EMIT result(data);
}
