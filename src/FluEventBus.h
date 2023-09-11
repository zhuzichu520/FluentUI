#ifndef FLUEVENTBUS_H
#define FLUEVENTBUS_H

#include <QObject>
#include <QtQml/qqml.h>
#include "stdafx.h"

class FluEvent : public QObject{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,name);
    QML_NAMED_ELEMENT(FluEvent)
public:
    explicit FluEvent(QObject *parent = nullptr);
    Q_SIGNAL void triggered(QMap<QString, QVariant> data);
};

class FluEventBus : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluEventBus)
    QML_SINGLETON
private:
    static FluEventBus* m_instance;
    explicit FluEventBus(QObject *parent = nullptr);
public:
    static FluEventBus *getInstance();
    static FluEventBus *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        return getInstance();
    }
    Q_INVOKABLE void registerEvent(FluEvent* event);
    Q_INVOKABLE void unRegisterEvent(FluEvent* event);
    Q_INVOKABLE void post(const QString& name,const QMap<QString, QVariant>& params = {});
private:
    QList<FluEvent*> eventData;
};

#endif // FLUEVENTBUS_H
