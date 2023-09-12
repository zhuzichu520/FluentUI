#ifndef FLUREGISTER_H
#define FLUREGISTER_H

#include <QObject>
#include <QQuickWindow>
#include <QJsonObject>
#include "stdafx.h"

/**
 * @brief The FluRegister class
 */
class FluRegister : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QQuickWindow*,from)
    Q_PROPERTY_AUTO(QQuickWindow*,to)
    Q_PROPERTY_AUTO(QString,path);
public:
    explicit FluRegister(QObject *parent = nullptr);
    Q_INVOKABLE void launch(const QJsonObject& argument  = {});
    Q_INVOKABLE void onResult(const QJsonObject& data  = {});
    Q_SIGNAL void result(const QJsonObject& data);
};

#endif // FLUREGISTER_H
