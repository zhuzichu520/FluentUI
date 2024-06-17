#pragma once

#include "macros.h"
#include <QtCore/QObject>
#include <QtGui/QColor>
#include <QtQml/qqml.h>

class QCPGrid;
class QCustomPlot;

namespace QmlQCustomPlot
{

class Grid : public QObject
{
    Q_OBJECT
    Q_ENUMS(LineType)
    QML_ELEMENT
    QML_UNCREATABLE("")
public:
    enum LineType
    {
        NoPen,
        SolidLine,
        DashLine,
        DotLine,
        DashDotLine,
        DashDotDotLine
    };
private:
    QML_READ_WRITE_NOTIFY_PROPERTY(bool, visible)
    QML_READ_WRITE_NOTIFY_PROPERTY(bool, subVisible)
    QML_READ_WRITE_NOTIFY_PROPERTY(int, lineWidth)
    QML_READ_WRITE_NOTIFY_PROPERTY(QColor, lineColor)
    QML_READ_WRITE_NOTIFY_PROPERTY(LineType, lineType)
    QML_READ_WRITE_NOTIFY_PROPERTY(int, subLineWidth)
    QML_READ_WRITE_NOTIFY_PROPERTY(QColor, subLineColor)
    QML_READ_WRITE_NOTIFY_PROPERTY(LineType, subLineType)
public:

    Grid(QCPGrid* grid, QCustomPlot *parentPlot, QObject *parent = nullptr);
    ~Grid();

    void set_visible(bool value) noexcept;
    void set_subVisible(bool value) noexcept;
    void set_lineWidth(int value) noexcept;
    void set_lineColor(const QColor &value) noexcept;
    void set_lineType(LineType value) noexcept;
    void set_subLineWidth(int value) noexcept;
    void set_subLineColor(const QColor &value) noexcept;
    void set_subLineType(LineType value) noexcept;

private:
    void updateProperty() noexcept;

private:
    QCustomPlot *m_parentPlot = nullptr;
    QCPGrid *m_qcpgrid = nullptr;
};

} // namespace QmlQCustomPlot
