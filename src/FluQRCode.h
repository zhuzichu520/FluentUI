#ifndef FLUQRCODE_H
#define FLUQRCODE_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

class FluQRCode : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,text)
    Q_PROPERTY_AUTO(QColor,color)
    Q_PROPERTY_AUTO(int,size);
    QML_NAMED_ELEMENT(FluQRCode)
public:
    explicit FluQRCode(QQuickItem *parent = nullptr);
    void paint(QPainter* painter) override;

};

#endif // FLUQRCODE_H
