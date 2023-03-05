#ifndef INSTALLHELPER_H
#define INSTALLHELPER_H

#include <QObject>
#include <QGuiApplication>
#include <QDebug>

#include "stdafx.h"


class InstallHelper : public QObject
{

    Q_OBJECT
    Q_PROPERTY_AUTO(bool,installing)
    Q_PROPERTY_AUTO(bool,uninstallSuccess)
    Q_PROPERTY_AUTO(QString,errorInfo)
public:
    explicit InstallHelper(QObject *parent = nullptr);

    Q_INVOKABLE void install(const QString& path,bool isHome,bool isStartMenu);

    Q_INVOKABLE QString applicationFilePath(){
        return QGuiApplication::arguments().join(" ");
    }

    Q_INVOKABLE bool isNavigateUninstall(){
        return QGuiApplication::arguments().contains("--uninstall");
//        return true;
    }

    Q_INVOKABLE bool isNavigateInstall();

    Q_INVOKABLE QString pid(){
        return QString::number(QCoreApplication::applicationPid());
    }

    Q_INVOKABLE void uninstall();
    static InstallHelper *getInstance();
private:
    static InstallHelper* m_instance;
};

#endif // INSTALLHELPER_H
