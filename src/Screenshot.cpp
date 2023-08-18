#include "Screenshot.h"
#include <QGuiApplication>
#include <QScreen>
#include <QQuickWindow>
#include <QDir>
#include <Def.h>
#include <QtMath>
#include <QThreadPool>

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
    _sourcePixmap = _desktopPixmap.copy();
    painter->drawPixmap(_desktopGeometry,_sourcePixmap);
    painter->restore();
}

void ScreenshotBackground::capture(const QPoint& start,const QPoint& end){
    auto pixelRatio = qApp->primaryScreen()->devicePixelRatio();
    auto x = qMin(start.x(),end.x()) * pixelRatio;
    auto y = qMin(start.y(),end.y()) * pixelRatio;
    auto w = qAbs(end.x()-start.x()) * pixelRatio;
    auto h = qAbs(end.y()-start.y()) * pixelRatio;
    _captureRect = QRect(x,y,w,h);
    if(_captureMode == FluScreenshotType::CaptrueMode::Pixmap){
        Q_EMIT captrueToPixmapCompleted(_sourcePixmap.copy(_captureRect));
    }
    if(_captureMode == FluScreenshotType::CaptrueMode::File){
        QDir dir = _saveFolder;
        if (!dir.exists(_saveFolder)){
            dir.mkpath(_saveFolder);
        }
        auto filePath = _saveFolder.append("/").append(QString::number(QDateTime::currentDateTime().toMSecsSinceEpoch())).append(".png");
        _sourcePixmap.copy(_captureRect).save(filePath);
        Q_EMIT captrueToFileCompleted(QUrl::fromLocalFile(filePath));
    }
}

