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
public:
    explicit InstallHelper(QObject *parent = nullptr);

    Q_INVOKABLE void install(const QString& path,bool isHome,bool isStartMenu);

    Q_INVOKABLE QString applicationFilePath(){
        return QGuiApplication::arguments().join(" ");
    }

    Q_INVOKABLE bool isNavigateUninstall(){
        return true;
//        return QGuiApplication::arguments().contains("--uninstall");
    }

    Q_INVOKABLE void uninstall();

};

#endif // INSTALLHELPER_H
