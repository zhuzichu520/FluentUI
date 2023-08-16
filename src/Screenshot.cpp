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
    connect(this,&Screenshot::startChanged,this,[=]{update();});
    connect(this,&Screenshot::endChanged,this,[=]{update();});
}

void Screenshot::paint(QPainter* painter)
{
    painter->save();
    painter->fillRect(_desktopGeometry,_maskColor);
    painter->setCompositionMode(QPainter::CompositionMode_Clear);
    painter->fillRect(QRect(_start.x(),_start.y(),_end.x()-_start.x(),_end.y()-_start.y()), Qt::black);
    painter->restore();
}

ScreenshotBackground::ScreenshotBackground(QQuickItem* parent) : QQuickPaintedItem(parent)
{

    _desktopGeometry = qApp->primaryScreen()->virtualGeometry();
    _desktopPixmap = qApp->primaryScreen()->grabWindow(0, _desktopGeometry.x(), _desktopGeometry.y(), _desktopGeometry.width(), _desktopGeometry.height());
}

void ScreenshotBackground::paint(QPainter* painter)
{
    painter->save();
    painter->drawPixmap(_desktopGeometry,_desktopPixmap);
    painter->restore();
}
