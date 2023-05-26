#ifndef FLUTEXTSTYLE_H
#define FLUTEXTSTYLE_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QFont>
#include <QJSEngine>
#include "stdafx.h"

class FluTextStyle : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY_AUTO(QFont,Caption);
    Q_PROPERTY_AUTO(QFont,Body);
    Q_PROPERTY_AUTO(QFont,BodyStrong);
    Q_PROPERTY_AUTO(QFont,Subtitle);
    Q_PROPERTY_AUTO(QFont,Title);
    Q_PROPERTY_AUTO(QFont,TitleLarge);
    Q_PROPERTY_AUTO(QFont,Display);
private:
    static FluTextStyle* m_instance;
    explicit FluTextStyle(QObject *parent = nullptr);
public:
    static FluTextStyle *getInstance();
    static QJSValue create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        Q_UNUSED(qmlEngine)
        return jsEngine->newQObject(getInstance());
    }

};

#endif // FLUTEXTSTYLE_H
