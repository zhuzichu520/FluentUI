#ifndef FLUWINDOWREGISTER_H
#define FLUWINDOWREGISTER_H

#include <QObject>
#include <QQuickWindow>
#include <QJsonObject>
#include "stdafx.h"

/**
 * @brief The FluWindowRegister class
 */
class FluWindowRegister : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QQuickWindow*,from)
    Q_PROPERTY_AUTO(QQuickWindow*,to)
    Q_PROPERTY_AUTO(QString,path);
public:
    explicit FluWindowRegister(QObject *parent = nullptr);
    Q_INVOKABLE void launch(const QJsonObject& argument  = {});
    Q_INVOKABLE void onResult(const QJsonObject& data  = {});
    Q_SIGNAL void result(const QJsonObject& data);
};

#endif // FLUWINDOWREGISTER_H
