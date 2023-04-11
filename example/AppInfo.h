#ifndef APPINFO_H
#define APPINFO_H

#include <QObject>
#include "stdafx.h"

class AppInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,version)
public:
    explicit AppInfo(QObject *parent = nullptr);
};

#endif // APPINFO_H
