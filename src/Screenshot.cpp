#include "Screenshot.h"
#include <QGuiApplication>
#include <QScreen>
#include <QQuickWindow>

Screenshot::Screenshot(QQuickItem* parent) : QQuickPaintedItem(parent)
{
    maskColor(QColor(0,0,0,80));
    start(QPoint(0,0));
    end(QPoint(0,0));
    _desktopGeometry = qApp->primaryScreen()->virtualGeometry();
    _desktopPixmap = qApp->primaryScreen()->grabWindow(0, _desktopGeometry.x(), _desktopGeometry.y(), _desktopGeometry.width(), _desktopGeometry.height());
    connect(this,&Screenshot::startChanged,this,[=]{update();});
    connect(this,&Screenshot::endChanged,this,[=]{update();});
}

void Screenshot::paint(QPainter* painter)
{
    painter->save();
    painter->eraseRect(boundingRect());
    painter->drawPixmap(_desktopGeometry,_desktopPixmap);
    painter->fillRect(_desktopGeometry,_maskColor);
    painter->setCompositionMode(QPainter::CompositionMode_Clear);
    painter->fillRect(QRect(_start.x(),_start.y(),_end.x()-_start.x(),_end.y()-_start.y()), Qt::black);
    painter->restore();
}
