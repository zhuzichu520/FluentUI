#ifndef SCREENSHOT_H
#define SCREENSHOT_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QQuickItemGrabResult>
#include "stdafx.h"

class ScreenshotBackground : public QQuickPaintedItem
{
    Q_OBJECT;
    QML_NAMED_ELEMENT(ScreenshotBackground)
    Q_PROPERTY_AUTO(QUrl,saveFolder);
    Q_PROPERTY_AUTO(int,captureMode);
public:
    ScreenshotBackground(QQuickItem* parent = nullptr);
    void paint(QPainter* painter) override;
    Q_SLOT void handleGrabResult();
    Q_INVOKABLE void capture(const QPoint& start,const QPoint& end);
    Q_SIGNAL void captrueToPixmapCompleted(QPixmap captrue);
    Q_SIGNAL void captrueToFileCompleted(QUrl captrue);
private:
    QRect _desktopGeometry;
    QPixmap _desktopPixmap;
    QPixmap _sourcePixmap;
    qreal _devicePixelRatio;
    QSharedPointer<QQuickItemGrabResult>  _grabResult;
    QRect _captureRect;
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
