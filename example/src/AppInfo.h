#ifndef APPINFO_H
#define APPINFO_H

#include <QObject>
#include <QQmlApplicationEngine>
#include "lang/Lang.h"
#include "stdafx.h"

class AppInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,version)
    Q_PROPERTY_AUTO(Lang*,lang)
public:
    explicit AppInfo(QObject *parent = nullptr);
    void init(QQmlApplicationEngine *engine);
    Q_INVOKABLE void changeLang(const QString& locale);
};

#endif // APPINFO_H
