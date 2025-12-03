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
        setFlag(QQuickItem::ItemHasContents, true); //启用内容绘制.
        setAcceptedMouseButtons(Qt::AllButtons);
        setAcceptHoverEvents(true);
        // 性能相关：尽可能减少抗锯齿和同步阻塞
        m_customPlot->setNotAntialiasedElements(QCP::aeAll);
        m_customPlot->setAntialiasedElements(QCP::AntialiasedElements());
        m_customPlot->setNoAntialiasingOnDrag(true);
        // 如需可尝试启用 OpenGL（Qt 版本与平台支持下）：
        // m_customPlot->setOpenGl(true, 0);
        connect(this, &QQuickPaintedItem::widthChanged, this, &BasePlot::onChartViewSizeChanged);
        connect(this, &QQuickPaintedItem::heightChanged, this, &BasePlot::onChartViewSizeChanged);
        connect(m_customPlot, &QCustomPlot::afterReplot, this, &BasePlot::onChartViewReplot, Qt::UniqueConnection);
        connect(&m_repaintTimer, &QTimer::timeout, this, &BasePlot::onRepaintTimer);
        m_repaintTimer.start(m_refreshMs);
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
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    void BasePlot::set_labelColor(const QColor &value)
    {
        m_labelColor = value;
        m_customPlot->xAxis->setLabelColor(m_labelColor);
        m_customPlot->yAxis->setLabelColor(m_labelColor);
        m_customPlot->xAxis->setTickLabelColor(m_labelColor);
        m_customPlot->yAxis->setTickLabelColor(m_labelColor);
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    void BasePlot::set_baseColor(const QColor &value)
    {
        m_baseColor = value;
        m_customPlot->xAxis->setBasePen(m_baseColor);
        m_customPlot->xAxis->setTickPen(m_baseColor);
        m_customPlot->xAxis->setSubTickPen(m_baseColor);
        m_customPlot->yAxis->setBasePen(m_baseColor);
        m_customPlot->yAxis->setTickPen(m_baseColor);
        m_customPlot->yAxis->setSubTickPen(m_baseColor);
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    void BasePlot::setInitialXRange(const QVariant &v)
    {
        // QML 会传入 JS 对象，所以手动转换
        if (v.canConvert<QVariantMap>()) {
            QVariantMap map = v.toMap();
            if (map.contains("lower") && map.contains("upper")) {
                m_initialXRange.lower = map["lower"].toDouble();
                m_initialXRange.upper = map["upper"].toDouble();
                m_customPlot->xAxis->setRange(m_initialXRange);
                emit initialYRangeChanged();
            }
        }
    }
    void BasePlot::setInitialYRange(const QVariant &v)
    {
        // QML 会传入 JS 对象，所以手动转换
        if (v.canConvert<QVariantMap>()) {
            QVariantMap map = v.toMap();
            if (map.contains("lower") && map.contains("upper")) {
                m_initialYRange.lower = map["lower"].toDouble();
                m_initialYRange.upper = map["upper"].toDouble();
                m_customPlot->yAxis->setRange(m_initialYRange);
                emit initialYRangeChanged();
            }
        }
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
    Q_INVOKABLE void BasePlot::rescaleAxes(const bool onlyVisiblePlottables) const
    {
        m_customPlot->rescaleAxes(onlyVisiblePlottables);
    }


    Q_INVOKABLE void BasePlot::requestRepaint() const {
        if (m_customPlot) m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    Q_INVOKABLE void BasePlot::moveY(double percent) const
    {
        if (!m_customPlot) return;
        auto *y = m_customPlot->yAxis;
        double range = y->range().size();
        y->setRange(y->range().lower + percent * range,
                    y->range().upper + percent * range);
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    Q_INVOKABLE void BasePlot::zoomX(double px, double factor, bool isScale) const
    {
        if (!m_customPlot) return;
        // qDebug() <<"x" << m_posCentor.first;
        auto *x = m_customPlot->xAxis;
        double xCentor = m_customPlot->xAxis->pixelToCoord(px);
        isScale ? x->scaleRange(factor) : zoomAxisToPoint(x, xCentor, factor);
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    Q_INVOKABLE void BasePlot::zoomY(double py, double factor, bool isScale) const
    {
        if (!m_customPlot) return;
        // qDebug() <<"y" << m_posCentor.second;
        auto *y = m_customPlot->yAxis;
        double yCentor = m_customPlot->xAxis->pixelToCoord(py);
        isScale ? y->scaleRange(factor) : zoomAxisToPoint(y, yCentor, factor);
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    Q_INVOKABLE void BasePlot::zoomXY(double px, double py, double factor, bool isScale) const
    {
        if (!m_customPlot) return;
        auto *x = m_customPlot->xAxis;
        auto *y = m_customPlot->yAxis;
        double xCentor = m_customPlot->xAxis->pixelToCoord(px);
        double yCentor = m_customPlot->xAxis->pixelToCoord(py);
        // qDebug()<<xCentor<<yCentor;
        isScale ? x->scaleRange(factor) : zoomAxisToPoint(x, xCentor, factor);
        isScale ? y->scaleRange(factor) : zoomAxisToPoint(y, yCentor, factor);
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    Q_INVOKABLE void BasePlot::resetRange() const
    {
        if (!m_customPlot) return;
        m_customPlot->xAxis->setRange(m_initialXRange);
        m_customPlot->yAxis->setRange(m_initialYRange);
        m_customPlot->replot(QCustomPlot::rpQueuedReplot);
    }
    Q_INVOKABLE void BasePlot::setRangeByPixels(double x1, double y1, double x2, double y2)
    {
        QCustomPlot *plot = customPlot();
        if (!plot) return;

        QCPAxis *xAxis = plot->xAxis;
        QCPAxis *yAxis = plot->yAxis;
        if (!xAxis || !yAxis) return;

        double dataX1 = xAxis->pixelToCoord(x1);
        double dataX2 = xAxis->pixelToCoord(x2);
        double dataY1 = yAxis->pixelToCoord(y1);
        double dataY2 = yAxis->pixelToCoord(y2);

        double xMin = qMin(dataX1, dataX2);
        double xMax = qMax(dataX1, dataX2);
        double yMin = qMin(dataY1, dataY2);
        double yMax = qMax(dataY1, dataY2);

        const double minRange = 1e-10;
        if (xMax - xMin < minRange || yMax - yMin < minRange) {
            return;
        }
        xAxis->setRange(xMin, xMax);
        yAxis->setRange(yMin, yMax);
        plot->replot(QCustomPlot::rpQueuedReplot);
    }

    QVariantMap BasePlot::graphs() const
    {
        QVariantMap map;
        for(auto it = m_graphs.begin(); it != m_graphs.end(); ++it) {
            map.insert(it.key(), QVariant::fromValue(it.value()));
        }
        return map;
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
        // 修改：增加右侧(10px)和顶部(10px)的最小边距，防止最大刻度标签被裁剪
        m_customPlot->axisRect()->setMinimumMargins (QMargins(0, 10, 10, 0));
        // m_customPlot->axisRect()->setMinimumMargins (QMargins(0, 0, 0, 0));
        // m_customPlot->axisRect()->setMargins(QMargins(0, 0, 0, 0));
    }
    //qml事件到Widget事件
    void BasePlot::routeMouseEvents(QMouseEvent *event) const {
        if (!event) {
            return;
        }
        if (!m_customPlot) {
            event->ignore();
            return;
        }
        auto* newEvent = new QMouseEvent(event->type(), event->position(), event->button(), event->buttons(), event->modifiers());
        QCoreApplication::postEvent(m_customPlot, newEvent);
        event->accept();

    }
    void BasePlot::routeWheelEvents(QWheelEvent *event) const {
        if (!event) {
            return;
        }
        if (!m_customPlot) {
            event->ignore();
            return;
        }
        auto* newEvent = new QWheelEvent(event->position(), event->globalPosition(),
                                        event->pixelDelta(), event->angleDelta(),
                                        event->buttons(), event->modifiers(),
                                        event->phase(), event->inverted());
        QCoreApplication::postEvent(m_customPlot, newEvent);
        event->accept();
    }

    void BasePlot::zoomAxisToPoint(QCPAxis *axis, double center, double factor) {
        // qDebug()<<"zoomAxisToPoint";
        if (center < axis->range().lower || center > axis->range().upper) {
            return;
        }
        QCPRange range = axis->range();
        double lower = center - (center - range.lower) * factor;
        double upper = center + (range.upper - center) * factor;
        axis->setRange(lower, upper);
    }

    Q_INVOKABLE void BasePlot::appendBatch(const QString &name, const QVector<double> &x, const QVector<double> &y, bool alreadySorted)
    {
        if(m_graphs.contains(name)) {
            m_graphs.value(name)->addDatas(x, y, alreadySorted);
        }
    }
    Q_INVOKABLE void BasePlot::appendBatch(const QVector<double> &x, const QVector<double> &y)
    {
        for(auto it = m_graphs.begin(); it != m_graphs.end(); ++it)
        {
            it.value()->addDatas(x, y, true);
        }
    }
    void BasePlot::updatePlot()
    {
        for(auto it = m_graphs.begin(); it != m_graphs.end(); ++it)
        {
            it.value()->clearData();
        }
        customPlot()->replot();
    }
    void BasePlot::setMaxBufferPoints(int n) {
        m_maxBufferPoints = qMax(1, n);
        emit maxBufferChanged();
    }
    void BasePlot::setRefreshMs(int ms) {
        m_refreshMs = qMax(5, ms);
        m_repaintTimer.start(m_refreshMs);
        emit refreshMsChanged();
    }
    void BasePlot::setPaused(bool p) {
        m_paused = p;
        emit pausedChanged();
    }

    void BasePlot::onRepaintTimer()
    {
        updatePlot();
    }
} // namespace QmlQCustomPlot   