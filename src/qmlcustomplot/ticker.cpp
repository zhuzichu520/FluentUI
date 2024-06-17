#include "ticker.h"
#include "qcustomplot.h"

#include <QPen>
#include <stdexcept>

namespace QmlQCustomPlot
{

Ticker::Ticker(QCPAxis* parentAxis, QCustomPlot *parentPlot, QObject *parent)
    : m_parentAxis(parentAxis), m_parentPlot(parentPlot), QObject(parent)
{
    if(parentPlot == nullptr || parentAxis == nullptr) 
        throw std::invalid_argument(nullptr);
        
    connect(parentPlot, &QCustomPlot::beforeReplot, this, &Ticker::updateProperty);
    updateProperty();
}

Ticker::~Ticker()
{
}

void Ticker::set_ticks(bool value) noexcept
{
    m_ticks = m_parentAxis->ticks();
    if(m_ticks == value) return;
    m_ticks = value;
    m_parentAxis->setTicks(value);
    Q_EMIT ticksChanged(m_ticks);
    m_parentPlot->replot();
}

void Ticker::set_subTicks(bool value) noexcept
{
    m_subTicks = m_parentAxis->subTicks();
    if(m_subTicks == value) return;
    m_subTicks = value;
    m_parentAxis->setSubTicks(value);
    Q_EMIT subTicksChanged(m_subTicks);
    m_parentPlot->replot();
}

void Ticker::set_tickCount(int value) noexcept
{
    m_tickCount = m_parentAxis->ticker()->tickCount();
    if(m_tickCount == value) return;
    m_tickCount = value;
    m_parentAxis->ticker()->setTickCount(value);
    Q_EMIT tickCountChanged(m_tickCount);
    m_parentPlot->replot();
}

void Ticker::set_baseWidth(int value) noexcept
{
    m_baseWidth = m_parentAxis->basePen().width();
    if(m_baseWidth == value) return;
    m_baseWidth = value;
    QPen pen = m_parentAxis->basePen();
    pen.setWidth(value);
    m_parentAxis->setBasePen(pen);
    Q_EMIT baseWidthChanged(m_baseWidth);
    m_parentPlot->replot();
}

void Ticker::set_baseColor(const QColor &value) noexcept
{
    m_baseColor = m_parentAxis->basePen().color();
    if(m_baseColor == value) return;
    m_baseColor = value;
    QPen pen = m_parentAxis->basePen();
    pen.setColor(value);
    m_parentAxis->setBasePen(pen);
    Q_EMIT baseColorChanged(m_baseColor);
    m_parentPlot->replot();
}

void Ticker::set_tickColor(const QColor &value) noexcept
{
    m_tickColor = m_parentAxis->tickPen().color();
    if(m_tickColor == value) return;
    m_tickColor = value;
    QPen pen = m_parentAxis->tickPen();
    pen.setColor(value);
    m_parentAxis->setTickPen(pen);
    Q_EMIT tickColorChanged(m_tickColor);
    m_parentPlot->replot();
}

void Ticker::set_subTickColor(const QColor &value) noexcept
{
    m_subTickColor = m_parentAxis->subTickPen().color();
    if(m_subTickColor == value) return;
    m_subTickColor = value;
    QPen pen = m_parentAxis->subTickPen();
    pen.setColor(value);
    m_parentAxis->setSubTickPen(pen);
    Q_EMIT subTickColorChanged(m_subTickColor);
    m_parentPlot->replot();
}

void Ticker::updateProperty() noexcept
{
    m_ticks = m_parentAxis->ticks();
    m_subTicks = m_parentAxis->subTicks();
    m_tickCount = m_parentAxis->ticker()->tickCount();
    m_baseWidth = m_parentAxis->basePen().width();
    m_baseColor = m_parentAxis->basePen().color();
    m_tickColor = m_parentAxis->tickPen().color();
    m_subTickColor = m_parentAxis->subTickPen().color();
    Q_EMIT ticksChanged(m_ticks);
    Q_EMIT subTicksChanged(m_subTicks);
    Q_EMIT tickCountChanged(m_tickCount);
    Q_EMIT baseWidthChanged(m_baseWidth);
    Q_EMIT baseColorChanged(m_baseColor);
    Q_EMIT tickColorChanged(m_tickColor);
    Q_EMIT subTickColorChanged(m_subTickColor);
}

}