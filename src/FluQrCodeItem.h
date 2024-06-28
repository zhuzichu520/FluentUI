#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

/**
 * @brief The FluQrCodeItem class
 */
class FluQrCodeItem : public QQuickPaintedItem {
    Q_OBJECT

    Q_PROPERTY_AUTO(QString, text)
    Q_PROPERTY_AUTO(QColor, color)
    Q_PROPERTY_AUTO(QColor, bgColor)
    Q_PROPERTY_AUTO(int, size)
    QML_NAMED_ELEMENT(FluQrCodeItem)
public:
    explicit FluQrCodeItem(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;
};
