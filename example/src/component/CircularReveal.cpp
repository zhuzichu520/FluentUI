#include "CircularReveal.h"
#include <QGuiApplication>
#include <QQuickItemGrabResult>
#include <QPainterPath>

CircularReveal::CircularReveal(QQuickItem *parent) : QQuickPaintedItem(parent) {
    _target = nullptr;
    _radius = 0;
    _anim = new QPropertyAnimation(this, "radius", this);
    _anim->setDuration(333);
    _anim->setEasingCurve(QEasingCurve::OutCubic);
    setVisible(false);
    connect(_anim, &QPropertyAnimation::finished, this, [=]() {
        update();
        setVisible(false);
        Q_EMIT animationFinished();
    });
    connect(this, &CircularReveal::radiusChanged, this, [=]() { update(); });
}

void CircularReveal::paint(QPainter *painter) {
    painter->save();
    painter->drawImage(QRect(0, 0, static_cast<int>(width()), static_cast<int>(height())), _source);
    QPainterPath path;
    path.moveTo(_center.x(), _center.y());
    path.addEllipse(QPointF(_center.x(), _center.y()), _radius, _radius);
    painter->setCompositionMode(QPainter::CompositionMode_Clear);
    if(_darkToLight){
        painter->fillPath(path, Qt::white);
    }else{
        QPainterPath outerRect;
        outerRect.addRect(0, 0, width(), height());
        outerRect = outerRect.subtracted(path);
        painter->fillPath(outerRect, Qt::black);
    }
    painter->restore();
}

[[maybe_unused]] void CircularReveal::start(int w, int h, const QPoint &center, int radius) {
    if (_anim->state() == QAbstractAnimation::Running) {
        _anim->stop();
        int currentRadius = _radius;
        _anim->setStartValue(currentRadius);
        _anim->setEndValue(_darkToLight ? 0 : radius);
    } else {
        if(_darkToLight){
            _anim->setStartValue(radius);
            _anim->setEndValue(0);
        }else{
            _anim->setStartValue(0);
            _anim->setEndValue(radius);
        }
    }
    _center = center;
    _grabResult = _target->grabToImage(QSize(w, h));
    connect(_grabResult.data(), &QQuickItemGrabResult::ready, this,
            &CircularReveal::handleGrabResult);
}

void CircularReveal::handleGrabResult() {
    _grabResult.data()->image().swap(_source);
    update();
    setVisible(true);
    Q_EMIT imageChanged();
    _anim->start();
}
