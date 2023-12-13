#include "QRCode.h"

#include "qrcode/qrencode.h"

QRCode::QRCode(QQuickItem* parent):QQuickPaintedItem(parent){
    color(QColor(0,0,0,255));
    bgColor(QColor(255,255,255,255));
    size(100);
    setWidth(_size);
    setHeight(_size);
    connect(this,&QRCode::textChanged,this,[=]{update();});
    connect(this,&QRCode::colorChanged,this,[=]{update();});
    connect(this,&QRCode::bgColorChanged,this,[=]{update();});
    connect(this,&QRCode::sizeChanged,this,[=]{
        setWidth(_size);
        setHeight(_size);
        update();
    });
}


void QRCode::paint(QPainter* painter){
    if(_text.isEmpty()){
        return;
    }
    if(_text.length()>1024){
        return;
    }
    painter->save();
    QRcode *qrcode = QRcode_encodeString(_text.toUtf8().constData(), 2, QR_ECLEVEL_Q, QR_MODE_8, 1);
    qint32 w = width();
    qint32 h = height();
    qint32 qrcodeW = qrcode->width > 0 ? qrcode->width : 1;
    double scaleX = (double)w / (double)qrcodeW;
    double scaleY = (double)h / (double)qrcodeW;
    QImage image = QImage(w, h, QImage::Format_ARGB32);
    QPainter p(&image);
    p.setBrush(_bgColor);
    p.setPen(Qt::NoPen);
    p.drawRect(0, 0, w, h);
    p.setBrush(_color);
    for (qint32 y = 0; y < qrcodeW; y++)
    {
        for (qint32 x = 0; x < qrcodeW; x++)
        {
            unsigned char b = qrcode->data[y*qrcodeW + x];
            if (b & 0x01)
            {
                QRectF r(x * scaleX,y * scaleY, scaleX, scaleY);
                p.drawRects(&r, 1);
            }
        }
    }
    QPixmap pixmap = QPixmap::fromImage(image);
    painter->drawPixmap(QRect(0, 0, static_cast<int>(width()), static_cast<int>(height())), pixmap);
    painter->restore();
}
