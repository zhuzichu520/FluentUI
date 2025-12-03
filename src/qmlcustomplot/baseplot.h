#pragma once

#include "macros.h"
#include "graph.h"
#include "axis.h"
#include "qcustomplot.h"
#include <QtGui/QColor>
#include <QtCore/QString>
#include <QtQuick/QQuickPaintedItem>

class QCustomPlot;

namespace QmlQCustomPlot
{
    class BasePlot : public QQuickPaintedItem
    {
        Q_OBJECT
        QML_ELEMENT

        QML_READ_WRITE_NOTIFY_PROPERTY(QColor, backgroundColor)
        QML_READ_WRITE_NOTIFY_PROPERTY(QColor , labelColor)
        QML_READ_WRITE_NOTIFY_PROPERTY(QColor , baseColor)
        QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, xAxis)
        QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, x1Axis)
        QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, yAxis)
        QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, y1Axis)

        Q_PROPERTY(int maxBufferPoints READ maxBufferPoints WRITE setMaxBufferPoints NOTIFY maxBufferChanged)
        Q_PROPERTY(int refreshMs READ refreshMs WRITE setRefreshMs NOTIFY refreshMsChanged)
        Q_PROPERTY(bool paused READ paused WRITE setPaused NOTIFY pausedChanged)
        Q_PROPERTY(QVariant initialXRange READ initialXRange WRITE setInitialXRange NOTIFY initialXRangeChanged)
        Q_PROPERTY(QVariant initialYRange READ initialYRange WRITE setInitialYRange NOTIFY initialYRangeChanged)
        Q_PROPERTY(QVariantMap graphs READ graphs NOTIFY graphsChanged)
    public:
        explicit BasePlot(QQuickItem *parent = nullptr);
        ~BasePlot() override;

        void set_backgroundColor(const QColor &value);
        void set_labelColor(const QColor &value);
        void set_baseColor(const QColor &value);
        [[nodiscard]] QVariant initialXRange() const { return QVariant::fromValue(m_initialXRange); }
        void setInitialXRange(const QVariant &v);
        [[nodiscard]] QVariant initialYRange() const { return QVariant::fromValue(m_initialYRange); }
        void setInitialYRange(const QVariant &v);

        void paint(QPainter *painter) override;
        int maxBufferPoints() const { return m_maxBufferPoints; }
        int refreshMs() const { return m_refreshMs; }
        bool paused() const { return m_paused; }


        Q_INVOKABLE void addGraph(const QString &key);
        Q_INVOKABLE void removeGraph(const QString &key);
        Q_INVOKABLE void rescaleAxes(bool onlyVisiblePlottables = false) const;

        Q_INVOKABLE void requestRepaint() const;
        Q_INVOKABLE void moveY(double percent) const;
        Q_INVOKABLE void zoomX(double px, double factor, bool isScale) const;
        Q_INVOKABLE void zoomY(double py, double factor, bool isScale) const;
        Q_INVOKABLE void zoomXY(double px, double py, double factor, bool isScale) const;
        Q_INVOKABLE void resetRange() const;
        Q_INVOKABLE void setRangeByPixels(double x1, double y1, double x2, double y2);

        [[nodiscard]] QCustomPlot *customPlot() const { return m_customPlot; }
        [[nodiscard]] QVariantMap graphs() const;
        [[nodiscard]] Graph* getGraph(const QString &key) const;

    protected:
        virtual void onChartViewReplot() { update(); }
        virtual void onChartViewSizeChanged();

        void hoverMoveEvent(QHoverEvent *event) override { Q_UNUSED(event) }
        void mousePressEvent(QMouseEvent *event) override { routeMouseEvents(event); }
        void mouseReleaseEvent(QMouseEvent *event) override { routeMouseEvents(event); }
        void mouseMoveEvent(QMouseEvent *event) override { routeMouseEvents(event); }
        void mouseDoubleClickEvent(QMouseEvent *event) override { routeMouseEvents(event); }
        void wheelEvent(QWheelEvent *event) override { routeWheelEvents(event); }
        void routeMouseEvents(QMouseEvent *event) const;
        void routeWheelEvents(QWheelEvent *event) const;

    private:
        static void zoomAxisToPoint(QCPAxis *axis, double center, double factor);

    public slots:
        Q_INVOKABLE virtual void appendBatch(const QString &name, const QVector<double> &x, const QVector<double> &y, bool alreadySorted);
        Q_INVOKABLE virtual void appendBatch(const QVector<double> &x, const QVector<double> &y);
        virtual void updatePlot();
        void setMaxBufferPoints(int n);
        void setRefreshMs(int ms);
        void setPaused(bool p);
        void onRepaintTimer();

    signals:
        void graphsChanged();
        void rangeChanged();
        void maxBufferChanged();
        void refreshMsChanged();
        void pausedChanged();
        void initialXRangeChanged();
        void initialYRangeChanged();

    private:
        QCustomPlot *m_customPlot = nullptr;
        QMap<QString, Graph *> m_graphs;

        QTimer m_repaintTimer;
        QCPRange m_initialXRange;
        QCPRange m_initialYRange;
        int m_maxBufferPoints = 20000;
        int m_refreshMs = 5;
        bool m_paused = false;
    };

} // namespace QmlQCustomPlot
