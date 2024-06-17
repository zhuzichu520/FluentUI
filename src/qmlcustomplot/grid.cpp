#include "grid.h"
#include "qcustomplot.h"

#include <QPen>
#include <stdexcept>

namespace QmlQCustomPlot
{

Grid::Grid(QCPGrid* grid, QCustomPlot *parentPlot, QObject *parent)
    : m_qcpgrid(grid), m_parentPlot(parentPlot), QObject(parent)
{
    if(parentPlot == nullptr || grid == nullptr) 
        throw std::invalid_argument(nullptr);
        
    connect(parentPlot, &QCustomPlot::beforeReplot, this, &Grid::updateProperty);
    updateProperty();
}

Grid::~Grid()
{
}

void Grid::set_visible(bool value) noexcept
{
    m_visible = m_qcpgrid->visible();
    if(m_visible == value) return;
    m_visible = value;
    m_qcpgrid->setVisible(value);
    Q_EMIT visibleChanged(m_visible);
    m_parentPlot->replot();
}

void Grid::set_subVisible(bool value) noexcept
{
    m_subVisible = m_qcpgrid->subGridVisible();
    if(m_subVisible == value) return;
    m_subVisible = value;
    m_qcpgrid->setSubGridVisible(value);
    Q_EMIT subVisibleChanged(m_subVisible);
    m_parentPlot->replot();
}

void Grid::set_lineWidth(int value) noexcept
{
    m_lineWidth = m_qcpgrid->pen().width();
    if(m_lineWidth == value) return;
    m_lineWidth = value;
    QPen pen = m_qcpgrid->pen();
    pen.setWidth(value);
    m_qcpgrid->setPen(pen);
    Q_EMIT lineWidthChanged(m_lineWidth);
    m_parentPlot->replot();
}

void Grid::set_lineColor(const QColor &value) noexcept
{
    m_lineColor = m_qcpgrid->pen().color();
    if(m_lineColor == value) return;
    m_lineColor = value;
    QPen pen = m_qcpgrid->pen();
    pen.setColor(value);
    m_qcpgrid->setPen(pen);
    Q_EMIT lineColorChanged(m_lineColor);
    m_parentPlot->replot();
}

void Grid::set_lineType(LineType value) noexcept
{
    m_lineType = static_cast<LineType>(m_qcpgrid->pen().style());
    if(m_lineType == value) return;
    m_lineType = value;
    QPen pen = m_qcpgrid->pen();
    pen.setStyle(static_cast<Qt::PenStyle>(value));
    m_qcpgrid->setPen(pen);
    Q_EMIT lineTypeChanged(m_lineType);
    m_parentPlot->replot();
}

void Grid::set_subLineWidth(int value) noexcept
{
    m_subLineWidth = m_qcpgrid->subGridPen().width();
    if(m_subLineWidth == value) return;
    m_subLineWidth = value;
    QPen pen = m_qcpgrid->subGridPen();
    pen.setWidth(value);
    m_qcpgrid->setSubGridPen(pen);
    Q_EMIT subLineWidthChanged(m_subLineWidth);
    m_parentPlot->replot();
}

void Grid::set_subLineColor(const QColor &value) noexcept
{
    m_subLineColor = m_qcpgrid->subGridPen().color();
    if(m_subLineColor == value) return;
    m_subLineColor = value;
    QPen pen = m_qcpgrid->subGridPen();
    pen.setColor(value);
    m_qcpgrid->setSubGridPen(pen);
    Q_EMIT subLineColorChanged(m_subLineColor);
    m_parentPlot->replot();
}

void Grid::set_subLineType(LineType value) noexcept
{
    m_subLineType = static_cast<LineType>(m_qcpgrid->subGridPen().style());
    if(m_subLineType == value) return;
    m_subLineType = value;
    QPen pen = m_qcpgrid->subGridPen();
    pen.setStyle(static_cast<Qt::PenStyle>(value));
    m_qcpgrid->setSubGridPen(pen);
    Q_EMIT subLineTypeChanged(m_subLineType);
    m_parentPlot->replot();
}

void Grid::updateProperty() noexcept
{
    m_visible = m_qcpgrid->visible();
    m_subVisible = m_qcpgrid->subGridVisible();
    m_lineWidth = m_qcpgrid->pen().width();
    m_lineColor = m_qcpgrid->pen().color();
    m_lineType = static_cast<LineType>(m_qcpgrid->pen().style());
    m_subLineWidth = m_qcpgrid->subGridPen().width();
    m_subLineColor = m_qcpgrid->subGridPen().color();
    m_subLineType = static_cast<LineType>(m_qcpgrid->subGridPen().style());
    Q_EMIT visibleChanged(m_visible);
    Q_EMIT subVisibleChanged(m_subVisible);
    Q_EMIT lineWidthChanged(m_lineWidth);
    Q_EMIT lineColorChanged(m_lineColor);
    Q_EMIT lineTypeChanged(m_lineType);
    Q_EMIT subLineWidthChanged(m_subLineWidth);
    Q_EMIT subLineColorChanged(m_subLineColor);
    Q_EMIT subLineTypeChanged(m_subLineType);
}

}