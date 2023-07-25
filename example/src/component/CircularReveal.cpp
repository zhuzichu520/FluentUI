#include "CircularReveal.h"
#include <QGuiApplication>
#include <QQuickItemGrabResult>
#include <QPainterPath>

CircularReveal::CircularReveal(QQuickItem* parent) : QQuickPaintedItem(parent)
{
    setVisible(false);
    _anim.setDuration(333);
    _anim.setEasingCurve(QEasingCurve::OutCubic);
    connect(&_anim, &QPropertyAnimation::finished,this,[=](){
        update();
        setVisible(false);
        Q_EMIT animationFinished();
    });
    connect(this,&CircularReveal::radiusChanged,this,[=](){
        update();
    });
}

void CircularReveal::paint(QPainter* painter)
{
    painter->save();
    painter->eraseRect(boundingRect());
    painter->drawImage(QRect(0, 0, static_cast<int>(width()), static_cast<int>(height())), _source);
    QPainterPath path;
    path.moveTo(_center.x(),_center.y());
    path.addEllipse(QPointF(_center.x(),_center.y()), _radius, _radius);
    painter->setCompositionMode(QPainter::CompositionMode_Clear);
    painter->fillPath(path, Qt::black);
    painter->restore();
}

void CircularReveal::start(int w,int h,const QPoint& center,int radius){
    _anim.setStartValue(0);
    _anim.setEndValue(radius);
    _center = center;
    _grabResult = _target->grabToImage(QSize(w,h));
    connect(_grabResult.data(), &QQuickItemGrabResult::ready, this, &CircularReveal::handleGrabResult);
}

void CircularReveal::handleGrabResult(){
    _grabResult.data()->image().swap(_source);
    update();
    setVisible(true);
    Q_EMIT imageChanged();
    _anim.start();
}
