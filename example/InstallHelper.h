#ifndef INSTALLHELPER_H
#define INSTALLHELPER_H

#include <QObject>
#include <QDebug>
#include "stdafx.h"

class InstallHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(bool,installing)
public:
    explicit InstallHelper(QObject *parent = nullptr);

    Q_INVOKABLE void install(const QString& path,bool isHome,bool isStartMenu);
signals:

};

#endif // INSTALLHELPER_H
