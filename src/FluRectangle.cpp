#include "FluRectangle.h"
#include <QPainterPath>

FluRectangle::FluRectangle(QQuickItem *parent) : QQuickPaintedItem(parent) {
    color(Qt::white);
    radius({0, 0, 0, 0});
    borderWidth(0);
    borderColor(Qt::black);
    connect(this, &FluRectangle::colorChanged, this, [=] { update(); });
    connect(this, &FluRectangle::radiusChanged, this, [=] { update(); });
    connect(this, &FluRectangle::borderWidthChanged, this, [=] { update(); });
    connect(this, &FluRectangle::borderColorChanged, this, [=] { update(); });
}

bool FluRectangle::borderValid() const {
    return qRound(_borderWidth) >= 1 && _color.isValid() && _color.alpha() > 0;
}

void FluRectangle::paint(QPainter *painter) {
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);

    QRectF rect = boundingRect();
    bool valid = borderValid();
    if (valid) {
        // 绘制边框时画笔的宽度从路径向两侧扩充
        // 因此实际绘制的矩形应向内侧收缩边框宽度的一半，避免边框裁剪导致不完整
        qreal halfBorderWidth = _borderWidth / 2.0;
        rect.adjust(halfBorderWidth, halfBorderWidth, -halfBorderWidth, -halfBorderWidth);
    }

    QPainterPath path;
    QList<int> r = _radius;

    while (r.size() < 4) {
        r.append(0);
    }

    // 从右下角开始逆时针绘制圆角矩形路径
    path.moveTo(rect.bottomRight() - QPointF(0, r[2]));
    path.lineTo(rect.topRight() + QPointF(0, r[1]));
    path.arcTo(QRectF(QPointF(rect.topRight() - QPointF(r[1] * 2, 0)), QSize(r[1] * 2, r[1] * 2)), 0, 90);

    path.lineTo(rect.topLeft() + QPointF(r[0], 0));
    path.arcTo(QRectF(QPointF(rect.topLeft()), QSize(r[0] * 2, r[0] * 2)), 90, 90);

    path.lineTo(rect.bottomLeft() - QPointF(0, r[3]));
    path.arcTo(QRectF(QPointF(rect.bottomLeft() - QPointF(0, r[3] * 2)), QSize(r[3] * 2, r[3] * 2)), 180, 90);

    path.lineTo(rect.bottomRight() - QPointF(r[2], 0));
    path.arcTo(QRectF(QPointF(rect.bottomRight() - QPointF(r[2] * 2, r[2] * 2)), QSize(r[2] * 2, r[2] * 2)), 270, 90);

    // 填充背景
    painter->fillPath(path, _color);

    // 绘制边框
    if (valid) {
        painter->strokePath(path, QPen(_borderColor, _borderWidth));
    }

    painter->restore();
}
