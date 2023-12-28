#include "AppInfo.h"

#include <QQmlContext>
#include <QDebug>
#include <QGuiApplication>
#include "Version.h"

AppInfo::AppInfo(QObject *parent)
    : QObject{parent}
{
    version(APPLICATION_VERSION);
}
