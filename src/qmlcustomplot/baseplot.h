#pragma once

#include "macros.h"
#include <QtGui/QColor>
#include <QtCore/QVariantMap>
#include <QtCore/QString>
#include <QtQuick/QQuickPaintedItem>

class QCustomPlot;

namespace QmlQCustomPlot
{

class Axis;
class Graph;
class BasePlot : public QQuickPaintedItem
{
    Q_OBJECT
    QML_READ_WRITE_NOTIFY_PROPERTY(QColor, backgroundColor)
    QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, xAxis)
    QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, x1Axis)
    QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, yAxis)
    QML_READ_NOTIFY_PROPERTY(QmlQCustomPlot::Axis *, y1Axis)
    QML_ELEMENT
    Q_PROPERTY(QVariantMap graphs READ graphs NOTIFY graphsChanged)
public:
    BasePlot(QQuickItem *parent = nullptr);
    ~BasePlot();

    void set_backgroundColor(const QColor &value);
    QVariantMap graphs() const;
    Q_SIGNAL void graphsChanged();
    Q_INVOKABLE void addGraph(const QString &key);
    Q_INVOKABLE void removeGraph(const QString &key);
    Q_INVOKABLE void rescaleAxes(bool onlyVisiblePlottables=false);

    void paint(QPainter *painter);
    QCustomPlot *customPlot() const { return m_customPlot; }
    const QMap<QString, Graph *> &graphsMap() const { return m_graphs; }
    Graph* getGraph(const QString &key) const;

protected:
    virtual void onChartViewReplot() { update(); }
    virtual void onChartViewSizeChanged();

    virtual void hoverMoveEvent(QHoverEvent *event) override { Q_UNUSED(event) }
    virtual void mousePressEvent(QMouseEvent *event) override { routeMouseEvents(event); }
    virtual void mouseReleaseEvent(QMouseEvent *event) override { routeMouseEvents(event); }
    virtual void mouseMoveEvent(QMouseEvent *event) override { routeMouseEvents(event); }
    virtual void mouseDoubleClickEvent(QMouseEvent *event) override { routeMouseEvents(event); }
    virtual void wheelEvent(QWheelEvent *event) override { routeWheelEvents(event); }
    void routeMouseEvents(QMouseEvent *event);
    void routeWheelEvents(QWheelEvent *event);

private:
    QCustomPlot *m_customPlot = nullptr;
    QMap<QString, Graph *> m_graphs;
};

} // namespace QmlQCustomPlot
