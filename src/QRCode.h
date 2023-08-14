#ifndef QRCODE_H
#define QRCODE_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

class QRCode : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,text)
    Q_PROPERTY_AUTO(QColor,color)
    Q_PROPERTY_AUTO(QColor,bgColor)
    Q_PROPERTY_AUTO(int,size);
    QML_NAMED_ELEMENT(QRCode)
public:
    explicit QRCode(QQuickItem *parent = nullptr);
    void paint(QPainter* painter) override;

};

#endif // QRCODE_H
