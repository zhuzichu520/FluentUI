#include "FluGlobal.h"

#include<QDebug>

namespace  FluentUI {

void preInit(){
    qDebug()<<"preInit";
}
void postInit(){
    qDebug()<<"postInit";
}
void initEngine(QQmlApplicationEngine* engine){
    qDebug()<<"initEngine";
}

}
