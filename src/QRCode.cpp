#include "QRCode.h"

#include "BarcodeFormat.h"
#include "BitMatrix.h"
#include "MultiFormatWriter.h"

using namespace ZXing;

QRCode::QRCode(QQuickItem* parent) : QQuickPaintedItem(parent)
{
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


void QRCode::paint(QPainter* painter)
{
    if(_text.isEmpty()){
        return;
    }
    if(_text.length()>1108){
        return;
    }
    painter->save();
    auto format = ZXing::BarcodeFormatFromString("QRCode");
    auto writer = MultiFormatWriter(format);
    writer.setMargin(0);
    writer.setEncoding(ZXing::CharacterSet::UTF8);
    auto matrix = writer.encode(_text.toUtf8().constData(), 0, 0);
    auto bitmap = ToMatrix<uint8_t>(matrix);
    auto image = QImage(bitmap.data(), bitmap.width(), bitmap.height(), bitmap.width(), QImage::Format::Format_Grayscale8).copy();
    QImage rgbImage = image.convertToFormat(QImage::Format_ARGB32);
    for (int y = 0; y < rgbImage.height(); ++y) {
        for (int x = 0; x < rgbImage.width(); ++x) {
            QRgb pixel = rgbImage.pixel(x, y);
            if (qRed(pixel) == 0 && qGreen(pixel) == 0 && qBlue(pixel) == 0) {
                rgbImage.setPixelColor(x, y, _color);
            }
            if (qRed(pixel) == 255 && qGreen(pixel) == 255 && qBlue(pixel) == 255) {
                rgbImage.setPixelColor(x, y, _bgColor);
            }
        }
    }
    painter->drawImage(QRect(0, 0, static_cast<int>(width()), static_cast<int>(height())), rgbImage);
    painter->restore();
}
