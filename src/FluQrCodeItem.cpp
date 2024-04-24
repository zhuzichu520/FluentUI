#include "FluQrCodeItem.h"

#include "qrcode/qrencode.h"

FluQrCodeItem::FluQrCodeItem(QQuickItem *parent) : QQuickPaintedItem(parent) {
    _color = QColor(0, 0, 0, 255);
    _bgColor = QColor(255, 255, 255, 255);
    _size = 100;
    setWidth(_size);
    setHeight(_size);
    connect(this, &FluQrCodeItem::textChanged, this, [=] { update(); });
    connect(this, &FluQrCodeItem::colorChanged, this, [=] { update(); });
    connect(this, &FluQrCodeItem::bgColorChanged, this, [=] { update(); });
    connect(this, &FluQrCodeItem::sizeChanged, this, [=] {
        setWidth(_size);
        setHeight(_size);
        update();
    });
}

void FluQrCodeItem::paint(QPainter *painter) {
    if (_text.isEmpty()) {
        return;
    }
    if (_text.length() > 1024) {
        return;
    }
    painter->save();
    QRcode *qrcode = QRcode_encodeString(_text.toUtf8().constData(), 2, QR_ECLEVEL_Q, QR_MODE_8, 1);
    auto w = qint32(width());
    auto h = qint32(height());
    qint32 qrcodeW = qrcode->width > 0 ? qrcode->width : 1;
    double scaleX = (double) w / (double) qrcodeW;
    double scaleY = (double) h / (double) qrcodeW;
    QImage image = QImage(w, h, QImage::Format_ARGB32);
    QPainter p(&image);
    p.setBrush(_bgColor);
    p.setPen(Qt::NoPen);
    p.drawRect(0, 0, w, h);
    p.setBrush(_color);
    for (qint32 y = 0; y < qrcodeW; y++) {
        for (qint32 x = 0; x < qrcodeW; x++) {
            unsigned char b = qrcode->data[y * qrcodeW + x];
            if (b & 0x01) {
                QRectF r(x * scaleX, y * scaleY, scaleX, scaleY);
                p.drawRects(&r, 1);
            }
        }
    }
    QPixmap pixmap = QPixmap::fromImage(image);
    painter->drawPixmap(QRect(0, 0, static_cast<int>(width()), static_cast<int>(height())), pixmap);
    painter->restore();
}
