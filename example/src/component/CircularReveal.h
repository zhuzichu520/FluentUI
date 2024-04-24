#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QPropertyAnimation>
#include "src/stdafx.h"

class CircularReveal : public QQuickPaintedItem {
Q_OBJECT
Q_PROPERTY_AUTO_P(QQuickItem*, target)
Q_PROPERTY_AUTO(int, radius)
public:
    explicit CircularReveal(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    Q_INVOKABLE [[maybe_unused]] void start(int w, int h, const QPoint &center, int radius);

    Q_SIGNAL void imageChanged();

    Q_SIGNAL void animationFinished();

    Q_SLOT void handleGrabResult();

private:
    QPropertyAnimation *_anim = nullptr;
    QImage _source;
    QPoint _center;
    QSharedPointer<QQuickItemGrabResult> _grabResult;
};
