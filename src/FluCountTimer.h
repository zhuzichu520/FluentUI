#pragma once

#include <QObject>
#include <QtQml/qqml.h>
#include <QTimer>
#include "stdafx.h"

/**
 * @brief The FluCountTimer class
 */
class FluCountTimer : public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(FluCountTimer)
public:
    enum CountType {
        Countdown,
        Countup
    };
    Q_ENUM(CountType)
    Q_PROPERTY_AUTO(CountType, countType)
    Q_PROPERTY_AUTO(int, value)
    Q_PROPERTY_AUTO(int, interval)
    Q_PROPERTY_AUTO(bool, running)
    Q_PROPERTY_AUTO(QString, format)
    Q_PROPERTY_READONLY_AUTO(int, hour)
    Q_PROPERTY_READONLY_AUTO(int, minute)
    Q_PROPERTY_READONLY_AUTO(int, second)
    Q_PROPERTY_READONLY_AUTO(int, millisecond)
    Q_PROPERTY_READONLY_AUTO(QString, time)

public:
    explicit FluCountTimer(QObject *parent = nullptr);

public Q_SLOTS:
    void start();
    void stop();
    void reset(int baseValue = 0);

Q_SIGNALS:
    void finished();

private Q_SLOTS:
    void onTimeout();
    void onRunningChanged();

private:
    void updateTime();
    QString formatTime() const;

    QTimer *_timer;
};
