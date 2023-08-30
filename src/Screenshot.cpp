#include "Screenshot.h"
#include <QGuiApplication>
#include <QScreen>
#include <QQuickWindow>
#include <QDir>
#include <QtMath>
#include <QDateTime>
#include <QThreadPool>

#include "Def.h"


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
    connect(this,&ScreenshotBackground::hitDrawDataChanged,this,[=]{update();});
}

void ScreenshotBackground::paint(QPainter* painter)
{
    painter->save();
    _sourcePixmap = _desktopPixmap.copy();
    foreach (auto item, _drawList) {
        if(item->drawType == 0){
            QPainter p(&_sourcePixmap);
            QPen pen;
            pen.setWidth(item->lineWidth);
            pen.setColor(QColor(255,0,0));
            pen.setStyle(Qt::SolidLine);
            p.setPen(pen);
            QRect rect(item->start.x(), item->start.y(), item->end.x()-item->start.x(), item->end.y()-item->start.y());
            p.drawRect(rect);
        }
    }
    painter->drawPixmap(_desktopGeometry,_sourcePixmap);
    foreach (auto item, _drawList) {
        if(item->drawType == 0){
            if(item == _hitDrawData){
                painter->setPen(QPen(QColor(255,0,0),3));
                painter->setBrush(QColor(255,255,255));
                painter->drawEllipse(QRect(item->start.x()-4,item->start.y()-4,8,8));
                painter->drawEllipse(QRect(item->start.x()+item->getWidth()/2-4,item->start.y()-4,8,8));
                painter->drawEllipse(QRect(item->start.x()+item->getWidth()-4,item->start.y()-4,8,8));
                painter->drawEllipse(QRect(item->start.x()+item->getWidth()-4,item->start.y()+item->getHeight()/2-4,8,8));
                painter->drawEllipse(QRect(item->start.x()+item->getWidth()-4,item->start.y()+item->getHeight()-4,8,8));
                painter->drawEllipse(QRect(item->start.x()+item->getWidth()/2-4,item->start.y()+item->getHeight()-4,8,8));
                painter->drawEllipse(QRect(item->start.x()-4,item->start.y()+item->getHeight()-4,8,8));
                painter->drawEllipse(QRect(item->start.x()-4,item->start.y()+item->getHeight()/2-4,8,8));
            }
        }
    }
    painter->restore();
}

void ScreenshotBackground::clear(){
    _drawList.clear();
    update();
}

DrawData* ScreenshotBackground::hit(const QPoint& point){
    foreach (auto item, _drawList) {
        if(item->drawType == 0){
            if(point.x()>=item->start.x()-mouseSpacing && point.x()<=item->start.x()+item->lineWidth+mouseSpacing && point.y()>=item->start.y()-mouseSpacing && point.y()<=item->end.y()+mouseSpacing){
                return item;
            }
            if(point.x()>=item->start.x()-mouseSpacing && point.x()<=item->end.x()+mouseSpacing && point.y()>=item->start.y()-mouseSpacing && point.y()<=item->start.y()+item->lineWidth+mouseSpacing){
                return item;
            }
            if(point.x()>=item->end.x()-item->lineWidth-mouseSpacing && point.x()<=item->end.x()+mouseSpacing && point.y()>=item->start.y()-mouseSpacing && point.y()<=item->end.y()+mouseSpacing){
                return item;
            }
            if(point.x()>=item->start.x()-mouseSpacing && point.x()<=item->end.x()+mouseSpacing && point.y()>=item->end.y()-item->lineWidth-mouseSpacing && point.y()<=item->end.y()+mouseSpacing){
                return item;
            }
        }
    }
    return nullptr;
}

void ScreenshotBackground::capture(const QPoint& start,const QPoint& end){
    hitDrawData(nullptr);
    update();
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

DrawData* ScreenshotBackground::appendDrawData(int drawType,QPoint start,QPoint end){
    DrawData *data = new DrawData(this);
    data->drawType = drawType;
    data->start = start;
    data->end = end;
    data->lineWidth = 3;
    _drawList.append(data);
    update();
    return data;
}

void ScreenshotBackground::updateDrawData(DrawData* data,QPoint start,QPoint end){
    data->start = start;
    data->end = end;
    update();
}

