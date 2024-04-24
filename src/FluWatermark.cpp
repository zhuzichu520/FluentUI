#include "FluWatermark.h"

#include "FluTextStyle.h"

FluWatermark::FluWatermark(QQuickItem *parent) : QQuickPaintedItem(parent) {
    _gap = QPoint(100, 100);
    _offset = QPoint(_gap.x() / 2, _gap.y() / 2);
    _rotate = 22;
    _textColor = QColor(222, 222, 222, 222);
    _textSize = 16;
    setZ(9999);
    connect(this, &FluWatermark::textColorChanged, this, [=] { update(); });
    connect(this, &FluWatermark::gapChanged, this, [=] { update(); });
    connect(this, &FluWatermark::offsetChanged, this, [=] { update(); });
    connect(this, &FluWatermark::textChanged, this, [=] { update(); });
    connect(this, &FluWatermark::rotateChanged, this, [=] { update(); });
    connect(this, &FluWatermark::textSizeChanged, this, [=] { update(); });
}

void FluWatermark::paint(QPainter *painter) {
    QFont font;
    font.setFamily(FluTextStyle::getInstance()->family());
    font.setPixelSize(_textSize);
    painter->setFont(font);
    painter->setPen(_textColor);
    QFontMetricsF fontMetrics(font);
    qreal fontWidth = fontMetrics.horizontalAdvance(_text);
    qreal fontHeight = fontMetrics.height();
    int stepX = qRound(fontWidth + _gap.x());
    int stepY = qRound(fontHeight + _gap.y());
    int rowCount = qRound(width() / stepX + 1);
    int colCount = qRound(height() / stepY + 1);
    for (int r = 0; r < rowCount; r++) {
        for (int c = 0; c < colCount; c++) {
            qreal centerX = stepX * r + _offset.x() + fontWidth / 2.0;
            qreal centerY = stepY * c + _offset.y() + fontHeight / 2.0;
            painter->save();
            painter->translate(centerX, centerY);
            painter->rotate(_rotate);
            painter->drawText(QRectF(-fontWidth / 2.0, -fontHeight / 2.0, fontWidth, fontHeight), _text);
            painter->restore();
        }
    }
}
