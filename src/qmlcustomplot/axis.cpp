#include "axis.h"
#include "grid.h"
#include "ticker.h"
#include "qcustomplot.h"

#include <stdexcept>

namespace QmlQCustomPlot
{

Axis::Axis(QObject *parent) :  QObject(parent)
{

}


Axis::Axis(QCPAxis* axis, QCustomPlot *parentPlot, QObject *parent)
    :  m_parentPlot(parentPlot), m_axis(axis), QObject(parent)
{
    if(parentPlot == nullptr || axis == nullptr) 
        throw std::invalid_argument(nullptr);
    connect(parentPlot, &QCustomPlot::beforeReplot, this, &Axis::updateProperty);
    connect(axis, &QCPAxis::destroyed, this, &Axis::deleteLater);
    m_ticker = new Ticker(axis, m_parentPlot, this);
    m_grid = new Grid(axis->grid(), m_parentPlot, this);
    updateProperty();
}

Axis::~Axis()
{

}

void Axis::setTickerType(TickerType type)
{
    QSharedPointer<QCPAxisTicker> ticker;
    switch (type)
    {
    default:
    case Fixed:
        ticker = QSharedPointer<QCPAxisTicker>(new QCPAxisTickerFixed);
        break;
    case Log:
        ticker = QSharedPointer<QCPAxisTicker>(new QCPAxisTickerLog);
        break;
    case Pi:
        ticker = QSharedPointer<QCPAxisTicker>(new QCPAxisTickerPi);
        break;
    case Text:
        ticker = QSharedPointer<QCPAxisTicker>(new QCPAxisTickerText);
        break;
    case DateTime:
        ticker = QSharedPointer<QCPAxisTicker>(new QCPAxisTickerDateTime);
        break;
    case Time:
        ticker = QSharedPointer<QCPAxisTicker>(new QCPAxisTickerTime);
        break;
    }
    m_axis->setTicker(ticker);
    m_parentPlot->replot();
}

void Axis::setRange(float position, float size, Qt::AlignmentFlag align) noexcept
{
    m_axis->setRange(position, size, align);
    // m_parentPlot->replot();
}

Q_INVOKABLE void Axis::setRange(float lower, float upper) noexcept
{
    m_axis->setRange(lower, upper);
    // m_parentPlot->replot();
}

void Axis::setTicker(QSharedPointer<QCPAxisTicker> ticker) noexcept
{
    m_axis->setTicker(ticker);
    m_parentPlot->replot();
}

void Axis::set_visible(bool value) noexcept
{
    m_visible = m_axis->visible();
    if(m_visible == value) return;
    m_visible = value;
    m_axis->setVisible(value);
    Q_EMIT visibleChanged(m_visible);
    m_parentPlot->replot();
}

void Axis::set_label(const QString &value) noexcept
{
    m_label = m_axis->label();
    if(m_label == value) return;
    m_label = value;
    m_axis->setLabel(value);
    Q_EMIT labelChanged(m_label);
    m_parentPlot->replot();
}

void Axis::set_upper(float value) noexcept
{
    m_upper = m_axis->range().upper;
    if(m_upper == value) return;
    m_upper = value;
    m_axis->setRangeLower(value);
    Q_EMIT upperChanged(m_upper);
    m_parentPlot->replot();
}

void Axis::set_lower(float value) noexcept
{
    m_lower = m_axis->range().lower;
    if(m_lower == value) return;
    m_lower = value;
    m_axis->setRangeUpper(value);
    Q_EMIT lowerChanged(m_lower);
    m_parentPlot->replot();
}

void Axis::updateProperty() noexcept
{
    m_visible = m_axis->visible();
    m_label = m_axis->label();
    m_upper = m_axis->range().upper;
    m_lower = m_axis->range().lower;
    Q_EMIT visibleChanged(m_visible);
    Q_EMIT labelChanged(m_label);
    Q_EMIT upperChanged(m_upper);
    Q_EMIT lowerChanged(m_lower);
}

} // namespace QmlQCustomPlot
