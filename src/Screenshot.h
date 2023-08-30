#ifndef SCREENSHOT_H
#define SCREENSHOT_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QQuickItemGrabResult>
#include "stdafx.h"
#include <qmath.h>

class DrawData:public QObject{
    Q_OBJECT;
public:
    explicit DrawData(QObject *parent = nullptr): QObject{parent}{};
    int drawType;
    int lineWidth;
    QPoint start;
    QPoint end;
    Q_INVOKABLE int getLineWidth(){
        return lineWidth;
    }
    Q_INVOKABLE int getWidth(){
        return end.x()-start.x();
    }
    Q_INVOKABLE int getHeight(){
        return end.y()-start.y();
    }
};

class ScreenshotBackground : public QQuickPaintedItem
{
    Q_OBJECT;
    QML_NAMED_ELEMENT(ScreenshotBackground)
    Q_PROPERTY_AUTO(QString,saveFolder);
    Q_PROPERTY_AUTO(int,captureMode);
    Q_PROPERTY_AUTO(DrawData*,hitDrawData);
public:
    ScreenshotBackground(QQuickItem* parent = nullptr);
    void paint(QPainter* painter) override;
    Q_INVOKABLE void capture(const QPoint& start,const QPoint& end);
    Q_INVOKABLE DrawData* appendDrawData(int drawType,QPoint start,QPoint end);
    Q_INVOKABLE void updateDrawData(DrawData* data,QPoint start,QPoint end);
    Q_INVOKABLE void clear();
    Q_INVOKABLE DrawData* hit(const QPoint& point);
    Q_SIGNAL void captrueToPixmapCompleted(QPixmap captrue);
    Q_SIGNAL void captrueToFileCompleted(QUrl captrue);
private:
    QRect _desktopGeometry;
    QPixmap _desktopPixmap;
    QPixmap _sourcePixmap;
    qreal _devicePixelRatio;
    QSharedPointer<QQuickItemGrabResult>  _grabResult;
    QRect _captureRect;
    QList<DrawData*> _drawList;
    int mouseSpacing = 3;
};


class Screenshot : public QQuickPaintedItem
{
    Q_OBJECT
    QML_NAMED_ELEMENT(Screenshot)
    Q_PROPERTY_AUTO(QPoint,start);
    Q_PROPERTY_AUTO(QPoint,end);
    Q_PROPERTY_AUTO(QColor,maskColor);
public:
    Screenshot(QQuickItem* parent = nullptr);
    void paint(QPainter* painter) override;

private:
    QRect _desktopGeometry;
};

#endif // SCREENSHOT_H
