#pragma once

#include "macros.h"
#include <QtCore/QObject>
#include <QtGui/QColor>

class QCPGraph;
class QCustomPlot;

namespace QmlQCustomPlot
{

class Graph : public QObject
{
    Q_OBJECT
    Q_ENUMS(LineType)
public:
    enum LineStyle
    {
        lsNone,
        lsLine,
        lsStepLeft,
        lsStepRight,
        lsStepCenter,
        lsImpulse
    };

private:
    QML_READ_WRITE_NOTIFY_PROPERTY(bool, visible)
    QML_READ_WRITE_NOTIFY_PROPERTY(bool, antialiased)
    QML_READ_WRITE_NOTIFY_PROPERTY(QString, name)
    QML_READ_WRITE_NOTIFY_PROPERTY(LineStyle, lineStyle)
    QML_READ_WRITE_NOTIFY_PROPERTY(int, graphWidth)
    QML_READ_WRITE_NOTIFY_PROPERTY(QColor, graphColor)
public:
    Graph(QCPGraph *graph, QCustomPlot *parentPlot, QObject *parent = nullptr);
    ~Graph();

    Q_INVOKABLE void setData(const QVector<double> &keys, const QVector<double> &values) noexcept;
    Q_INVOKABLE void setData(const QVector<double> &keys, const QVector<double> &values, bool alreadySorted) noexcept;
    Q_INVOKABLE void addDatas(const QVector<double> &keys, const QVector<double> &values, bool alreadySorted) noexcept;
    Q_INVOKABLE void addData(double key, double value) noexcept;
    Q_INVOKABLE void removeDataBefore(double key) noexcept;
    Q_INVOKABLE void clearData() noexcept;
    void set_visible(bool value) noexcept;
    void set_antialiased(bool value) noexcept;
    void set_name(const QString &value) noexcept;
    void set_lineStyle(LineStyle value) noexcept;
    void set_graphWidth(int value) noexcept;
    void set_graphColor(const QColor &value) noexcept;

private:
    void updateProperty() noexcept;

private:
    QCustomPlot *m_parentPlot = nullptr;
    QCPGraph *m_graph = nullptr;
};

} // namespace QmlQCustomPlot
