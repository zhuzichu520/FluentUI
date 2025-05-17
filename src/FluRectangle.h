#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

/**
 * @brief The FluRectangle class
 */
class FluRectangle : public QQuickPaintedItem {
    Q_OBJECT
    Q_PROPERTY_AUTO(QColor, color)
    Q_PROPERTY_AUTO(QList<int>, radius)
    Q_PROPERTY_AUTO(qreal, borderWidth)
    Q_PROPERTY_AUTO(QColor, borderColor)
    Q_PROPERTY_AUTO(Qt::PenStyle, borderStyle)
    Q_PROPERTY_AUTO(QVector<qreal>, dashPattern)
    QML_NAMED_ELEMENT(FluRectangle)
public:
    explicit FluRectangle(QQuickItem *parent = nullptr);

    bool borderValid() const;

    void paint(QPainter *painter) override;
};
