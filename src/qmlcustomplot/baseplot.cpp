#include "baseplot.h"
#include "axis.h"
#include "graph.h"
#include "qcustomplot.h"

#include <stdexcept>

namespace QmlQCustomPlot
{


BasePlot::BasePlot(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_customPlot(new QCustomPlot())
{
    setFlag(QQuickItem::ItemHasContents, true);
    setAcceptedMouseButtons(Qt::AllButtons);
    setAcceptHoverEvents(true);  
    connect(this, &QQuickPaintedItem::widthChanged, this, &BasePlot::onChartViewSizeChanged);
    connect(this, &QQuickPaintedItem::heightChanged, this, &BasePlot::onChartViewSizeChanged);   
    connect(m_customPlot, &QCustomPlot::afterReplot, this, &BasePlot::onChartViewReplot, Qt::UniqueConnection);
    try {
        m_xAxis = new Axis(m_customPlot->xAxis, m_customPlot, this);
        m_x1Axis = new Axis(m_customPlot->xAxis2, m_customPlot, this);
        m_yAxis = new Axis(m_customPlot->yAxis, m_customPlot, this);
        m_y1Axis = new Axis(m_customPlot->yAxis2, m_customPlot, this);
        connect(m_xAxis, &Axis::destroyed, this, [this]{ m_xAxis = nullptr; Q_EMIT xAxisChanged(nullptr); });
        connect(m_x1Axis, &Axis::destroyed, this, [this]{ m_x1Axis = nullptr; Q_EMIT x1AxisChanged(nullptr);});
        connect(m_yAxis, &Axis::destroyed, this, [this]{ m_yAxis = nullptr; Q_EMIT yAxisChanged(nullptr); });
        connect(m_y1Axis, &Axis::destroyed, this, [this]{ m_y1Axis = nullptr; Q_EMIT y1AxisChanged(nullptr);});
        connect(m_customPlot->xAxis, SIGNAL(rangeChanged(QCPRange)), m_customPlot->xAxis2, SLOT(setRange(QCPRange)));
        connect(m_customPlot->yAxis, SIGNAL(rangeChanged(QCPRange)), m_customPlot->yAxis2, SLOT(setRange(QCPRange)));
   
    }
    catch(const std::exception &e) {
        qCritical() << e.what();
        m_xAxis = nullptr;
        m_x1Axis = nullptr;
        m_yAxis = nullptr;
        m_y1Axis = nullptr;
    }
    update();
}

BasePlot::~BasePlot()
{
    delete m_customPlot;
}

void BasePlot::set_backgroundColor(const QColor &value)
{
    // m_backgroundColor = m_customPlot->background().toImage().pixelColor(0, 0);
    if(m_backgroundColor == value) return;
    m_backgroundColor = value;
    m_customPlot->setBackground(QBrush(m_backgroundColor));
    // m_customPlot->axisRect()->setBackground(QBrush(m_backgroundColor));
    emit backgroundColorChanged(m_backgroundColor);
    m_customPlot->replot();
}

QVariantMap BasePlot::graphs() const
{
    QVariantMap map;
    for(auto it = m_graphs.begin(); it != m_graphs.end(); ++it) {
        map.insert(it.key(), QVariant::fromValue(it.value()));
    }
    return map;
}

Q_INVOKABLE void BasePlot::addGraph(const QString &key)
{
    if(m_graphs.contains(key)) return;

    auto g = m_customPlot->addGraph();
    if(g == nullptr) return;
    g->setName(key);
    auto graph = new Graph(g, m_customPlot, this);
    m_graphs.insert(key, graph);
    emit graphsChanged();
}

Q_INVOKABLE void BasePlot::removeGraph(const QString &key)
{
    if(m_graphs.contains(key)) {
        auto graph = m_graphs.take(key);
        delete graph;
        emit graphsChanged();
    }
}

Q_INVOKABLE void BasePlot::rescaleAxes(bool onlyVisiblePlottables)
{
    m_customPlot->rescaleAxes(onlyVisiblePlottables);
}

Graph *BasePlot::getGraph(const QString &key) const
{
    if(m_graphs.contains(key)) {
        return m_graphs.value(key);
    }
    return nullptr;
}

void BasePlot::paint(QPainter *painter)
{
    if (!painter->isActive())
        return;
    QPixmap picture( boundingRect().size().toSize() );
    QCPPainter qcpPainter( &picture );
    m_customPlot->toPainter(&qcpPainter);
    painter->drawPixmap(QPoint(), picture);
}

void BasePlot::onChartViewSizeChanged()
{
    m_customPlot->setGeometry(0, 0, (int)width(), (int)height());
    m_customPlot->setViewport(QRect(0, 0, (int)width(), (int)height()));
    m_customPlot->axisRect()->setOuterRect(QRect(0, 0, (int)width(), (int)height()));
    m_customPlot->axisRect()->setMinimumMargins (QMargins(0, 0, 0, 0));
    m_customPlot->axisRect()->setMargins(QMargins(0, 0, 0, 0));
}

void BasePlot::routeMouseEvents(QMouseEvent *event)
{
    QMouseEvent* newEvent = new QMouseEvent(event->type(), event->localPos(), event->button(), event->buttons(), event->modifiers());
    QCoreApplication::postEvent(m_customPlot, newEvent);
}

void BasePlot::routeWheelEvents(QWheelEvent *event)
{
    QWheelEvent* newEvent = new QWheelEvent(event->position(), event->globalPosition(),
                                            event->pixelDelta(), event->angleDelta(), 
                                            event->buttons(), event->modifiers(), 
                                            event->phase(), event->inverted());
    QCoreApplication::postEvent(m_customPlot, newEvent);
}

} // namespace QmlQCustomPlot   