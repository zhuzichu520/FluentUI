#pragma once

#include "macros.h"
#include <QtCore/QObject>
#include <QtGui/QColor>
#include <QtQml/qqml.h>

class QCPAxis;
class QCustomPlot;

namespace QmlQCustomPlot
{

class Ticker : public QObject
{
    Q_OBJECT
    QML_READ_WRITE_NOTIFY_PROPERTY(bool, ticks)
    QML_READ_WRITE_NOTIFY_PROPERTY(bool, subTicks)
    QML_READ_WRITE_NOTIFY_PROPERTY(int, tickCount)
    QML_READ_WRITE_NOTIFY_PROPERTY(int, baseWidth)
    QML_READ_WRITE_NOTIFY_PROPERTY(QColor, baseColor)
    QML_READ_WRITE_NOTIFY_PROPERTY(QColor, tickColor)
    QML_READ_WRITE_NOTIFY_PROPERTY(QColor, subTickColor)
    QML_ELEMENT
    QML_UNCREATABLE("")
public:

    Ticker(QCPAxis* parentAxis, QCustomPlot *parentPlot, QObject *parent = nullptr);
    ~Ticker();

    void set_ticks(bool value) noexcept;
    void set_subTicks(bool value) noexcept;
    void set_tickCount(int value) noexcept;
    void set_baseWidth(int value) noexcept;
    void set_baseColor(const QColor &value) noexcept;
    void set_tickColor(const QColor &value) noexcept;
    void set_subTickColor(const QColor &value) noexcept;

private:
    void updateProperty() noexcept;

private:
    QCustomPlot *m_parentPlot = nullptr;
    QCPAxis* m_parentAxis = nullptr;
};

} // namespace QmlQCustomPlot
