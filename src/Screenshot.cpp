#include "Screenshot.h"
#include <QGuiApplication>
#include <QScreen>
#include <QQuickWindow>
#include <QtMath>

Screenshot::Screenshot(QQuickItem* parent) : QQuickPaintedItem(parent)
{
    _desktopGeometry = qApp->primaryScreen()->virtualGeometry();
    maskColor(QColor(0,0,0,80));
    start(QPoint(0,0));
    end(QPoint(0,0));
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
    _devicePixelRatio = qApp->primaryScreen()->devicePixelRatio();
    _desktopGeometry = qApp->primaryScreen()->virtualGeometry();
    _desktopPixmap = qApp->primaryScreen()->grabWindow(0, _desktopGeometry.x(), _desktopGeometry.y(), _desktopGeometry.width(), _desktopGeometry.height());
    int w = qApp->primaryScreen()->geometry().width();
    int h = qApp->primaryScreen()->geometry().height();
    foreach (auto item, qApp->screens()) {
        if(item != qApp->primaryScreen()){
            w = w + item->geometry().width()/qApp->primaryScreen()->devicePixelRatio();
        }
    }
    setWidth(w);
    setHeight(h);
}

void ScreenshotBackground::paint(QPainter* painter)
{
    painter->save();
    _sourcePixmap = QPixmap(QSize(_desktopGeometry.width(),_desktopGeometry.height()));
    QPainter p(&_sourcePixmap);
    p.drawPixmap(_desktopGeometry,_desktopPixmap);
    painter->drawPixmap(_desktopGeometry,_sourcePixmap);
    painter->restore();
}

void ScreenshotBackground::capture(const QPoint& start,const QPoint& end){
    _grabResult = grabToImage();
    auto x = qMin(start.x(),end.x());
    auto y = qMin(start.y(),end.y());
    auto w = qAbs(end.x()-start.x());
    auto h = qAbs(end.y()-start.y());
    _captureRect = QRect(x,y,w,h);
    connect(_grabResult.data(), &QQuickItemGrabResult::ready, this, &ScreenshotBackground::handleGrabResult);
}

void ScreenshotBackground::handleGrabResult(){
    _sourcePixmap.copy(_captureRect).save("aaa.png");
}

