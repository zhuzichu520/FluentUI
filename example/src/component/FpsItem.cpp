#include "FpsItem.h"

#include <QTimer>
#include <QQuickWindow>

FpsItem::FpsItem()
{
    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, [this]{
        fps(_frameCount);
        _frameCount = 0;
    });
    connect(this, &QQuickItem::windowChanged, this, [this]{
        if (window()){
            connect(window(), &QQuickWindow::afterRendering, this, [this]{ _frameCount++; }, Qt::DirectConnection);
        }
    });
    timer->start(1000);
}
