#include "FluRectangle.h"
#include <QPainterPath>

FluRectangle::FluRectangle(QQuickItem *parent) : QQuickPaintedItem(parent) {
    color(QColor(255, 255, 255, 255));
    radius({0, 0, 0, 0});
    connect(this, &FluRectangle::colorChanged, this, [=] { update(); });
    connect(this, &FluRectangle::radiusChanged, this, [=] { update(); });
}

void FluRectangle::paint(QPainter *painter) {
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);
    QPainterPath path;
    QRectF rect = boundingRect();
    path.moveTo(rect.bottomRight() - QPointF(0, _radius[2]));
    path.lineTo(rect.topRight() + QPointF(0, _radius[1]));
    path.arcTo(QRectF(QPointF(rect.topRight() - QPointF(_radius[1] * 2, 0)), QSize(_radius[1] * 2, _radius[1] * 2)), 0, 90);
    path.lineTo(rect.topLeft() + QPointF(_radius[0], 0));
    path.arcTo(QRectF(QPointF(rect.topLeft()), QSize(_radius[0] * 2, _radius[0] * 2)), 90, 90);
    path.lineTo(rect.bottomLeft() - QPointF(0, _radius[3]));
    path.arcTo(QRectF(QPointF(rect.bottomLeft() - QPointF(0, _radius[3] * 2)), QSize(_radius[3] * 2, _radius[3] * 2)), 180, 90);
    path.lineTo(rect.bottomRight() - QPointF(_radius[2], 0));
    path.arcTo(QRectF(QPointF(rect.bottomRight() - QPointF(_radius[2] * 2, _radius[2] * 2)), QSize(_radius[2] * 2, _radius[2] * 2)), 270, 90);
    painter->fillPath(path, _color);
    painter->restore();
}
