#include "InstallHelper.h"

InstallHelper::InstallHelper(QObject *parent)
    : QObject{parent}
{
    installing(false);
}

void InstallHelper::install(const QString& path,bool isHome,bool isStartMenu){
    installing(true);
    qDebug()<<path;
}
