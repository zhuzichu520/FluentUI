#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

/**
 * @brief The FluWatermark class
 */
class FluWatermark : public QQuickPaintedItem {
Q_OBJECT
Q_PROPERTY_AUTO(QString, text)
Q_PROPERTY_AUTO(QPoint, gap)
Q_PROPERTY_AUTO(QPoint, offset);
Q_PROPERTY_AUTO(QColor, textColor);
Q_PROPERTY_AUTO(int, rotate);
Q_PROPERTY_AUTO(int, textSize);
    QML_NAMED_ELEMENT(FluWatermark)
public:
    explicit FluWatermark(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;
};
