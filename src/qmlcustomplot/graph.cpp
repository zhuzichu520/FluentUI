#include "graph.h"
#include "qcustomplot.h"

#include <QPen>
#include <stdexcept>

namespace QmlQCustomPlot
{

Graph::Graph(QCPGraph* graph, QCustomPlot *parentPlot, QObject *parent)
    : m_graph(graph), m_parentPlot(parentPlot), QObject(parent)
{
    if(parentPlot == nullptr || graph == nullptr) 
        throw std::invalid_argument(nullptr);
        
    connect(parentPlot, &QCustomPlot::beforeReplot, this, &Graph::updateProperty);
    updateProperty();
}

Graph::~Graph()
{
}

void Graph::setData(const QVector<double> &keys, const QVector<double> &values) noexcept
{
    m_graph->setData(keys, values);
    m_parentPlot->replot();
}

void Graph::addData(double key, double value) noexcept
{
    m_graph->addData(key, value);
    m_parentPlot->replot();
}

void Graph::removeDataBefore(double key) noexcept
{
    m_graph->data()->removeBefore(key);
    m_parentPlot->replot();
}

void Graph::clearData() noexcept
{
    m_graph->data()->clear();
    m_parentPlot->replot();
}

void Graph::set_visible(bool value) noexcept
{
    m_visible = m_graph->visible();
    if(m_visible == value) return;
    m_visible = value;
    m_graph->setVisible(value);
    Q_EMIT visibleChanged(m_visible);
    m_parentPlot->replot();
}

void Graph::set_antialiased(bool value) noexcept
{
    m_antialiased = m_graph->antialiased();
    if(m_antialiased == value) return;
    m_antialiased = value;
    m_graph->setAntialiased(value);
    Q_EMIT antialiasedChanged(m_antialiased);
    m_parentPlot->replot();
}

void Graph::set_name(const QString &value) noexcept
{
    m_name = m_graph->name();
    if(m_name == value) return;
    m_name = value;
    m_graph->setName(value);
    Q_EMIT nameChanged(m_name);
    m_parentPlot->replot();
}

void Graph::set_lineStyle(LineStyle value) noexcept
{
    m_lineStyle = static_cast<Graph::LineStyle>(m_graph->lineStyle());
    if(m_lineStyle == value) return;
    m_lineStyle = value;
    m_graph->setLineStyle(static_cast<QCPGraph::LineStyle>(value));
    Q_EMIT lineStyleChanged(m_lineStyle);
    m_parentPlot->replot();
}

void Graph::set_graphWidth(int value) noexcept
{
    m_graphWidth = m_graph->pen().width();
    if(m_graphWidth == value) return;
    m_graphWidth = value;
    QPen pen = m_graph->pen();
    pen.setWidth(value);
    m_graph->setPen(pen);
    Q_EMIT graphWidthChanged(m_graphWidth);
    m_parentPlot->replot();
}

void Graph::set_graphColor(const QColor &value) noexcept
{
    m_graphColor = m_graph->pen().color();
    if(m_graphColor == value) return;
    m_graphColor = value;
    QPen pen = m_graph->pen();
    pen.setColor(value);
    m_graph->setPen(pen);
    Q_EMIT graphColorChanged(m_graphColor);
    m_parentPlot->replot();
}

void Graph::updateProperty() noexcept
{
    m_visible = m_graph->visible();
    m_antialiased = m_graph->antialiased();
    m_name = m_graph->name();
    m_lineStyle = static_cast<Graph::LineStyle>(m_graph->lineStyle());
    m_graphWidth = m_graph->pen().width();
    m_graphColor = m_graph->pen().color();
    Q_EMIT visibleChanged(m_visible);
    Q_EMIT antialiasedChanged(m_antialiased);
    Q_EMIT nameChanged(m_name);
    Q_EMIT lineStyleChanged(m_lineStyle);
    Q_EMIT graphWidthChanged(m_graphWidth);
    Q_EMIT graphColorChanged(m_graphColor);
}

}