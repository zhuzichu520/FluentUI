#include "FluCaptcha.h"
#include <QTime>
#include <QChar>
#include <QPainter>
#include <QRandomGenerator>
#include <QDebug>

namespace {
int randInt(int number) {
    return QRandomGenerator::global()->bounded(0, number);
}

qreal randReal(qreal min = 0.0, qreal max = 1.0) {
    return min + QRandomGenerator::global()->bounded(max - min);
}
}

FluCaptcha::FluCaptcha(QQuickItem *parent) : QQuickPaintedItem(parent)
                                             , _ignoreCase(false)
                                             , _noiseCount(-1)
                                             , _noiseRadius(1.5)
                                             , _lineCount(-1)
                                             , _lineWidthMin(1.0)
                                             , _lineWidthMax(2.0) {
    QFont fontStyle;
#ifdef Q_OS_WIN
    fontStyle.setFamily("微软雅黑");
#endif
    fontStyle.setPixelSize(28);
    fontStyle.setBold(true);
    font(fontStyle);
    setWidth(180);
    setHeight(80);
    refresh();
    auto repaint = [this]() {
        update();
    };
    connect(this, &FluCaptcha::noiseCountChanged, this, repaint);
    connect(this, &FluCaptcha::noiseRadiusChanged, this, repaint);
    connect(this, &FluCaptcha::lineCountChanged, this, repaint);
    connect(this, &FluCaptcha::lineWidthMinChanged, this, repaint);
    connect(this, &FluCaptcha::lineWidthMaxChanged, this, repaint);
}

#include <QtMath>
void FluCaptcha::paint(QPainter *painter) {
    QRectF rect = boundingRect();
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, true);
    painter->fillRect(rect, Qt::white);
    painter->setFont(_font);
    // noise
    int actualNoiseCount = _noiseCount;
    if (actualNoiseCount < 0) {
        qreal area = rect.width() * rect.height();
        actualNoiseCount = qBound(20, static_cast<int>(area / 25), 100);
    }
    if (actualNoiseCount > 0 && _noiseRadius >= 0) {
        QPen noisePen;
        QBrush noiseBrush;
        noiseBrush.setStyle(Qt::SolidPattern);
        for (int i = 0; i < actualNoiseCount; i++) {
            QColor color(randInt(256), randInt(256), randInt(256));
            noisePen.setColor(color);
            noiseBrush.setColor(color);
            painter->setPen(noisePen);
            painter->setBrush(noiseBrush);

            int x = randInt(static_cast<int>(rect.width()));
            int y = randInt(static_cast<int>(rect.height()));
            if (_noiseRadius <= 1.0) {
                painter->drawPoint(x, y);
            } else {
                qreal r = _noiseRadius * randReal(0.7, 1.2);
                painter->drawEllipse(QPointF(x, y), r, r);
            }
        }
    }
    // line
    int actualLineCount = _lineCount < 0 ? qMax(1, static_cast<int>(rect.height() / 15)) : _lineCount;
    if (actualLineCount > 0 && _lineWidthMax > 0) {
        QPen linePen;
        linePen.setCapStyle(Qt::RoundCap);
        linePen.setJoinStyle(Qt::RoundJoin);
        for (int i = 0; i < actualLineCount; i++) {
            QLineF line(randInt(static_cast<int>(rect.width())), randInt(static_cast<int>(rect.height())),
                        randInt(static_cast<int>(rect.width())), randInt(static_cast<int>(rect.height())));
            qreal t = randReal();
            qreal lineWidth = _lineWidthMin >= _lineWidthMax ? _lineWidthMin : (_lineWidthMin + t * (_lineWidthMax - _lineWidthMin));
            linePen.setWidthF(lineWidth);
            linePen.setColor(QColor(randInt(256), randInt(256), randInt(256)));
            painter->setPen(linePen);
            painter->drawLine(line);
        }
    }
    // text
    int charCount = _code.length();
    qreal charWidth = rect.width() / charCount;
    qreal fontSize = qSqrt(rect.width() * rect.height()) * 0.35;
    QFont textFont = _font;
    textFont.setPixelSize(static_cast<int>(fontSize));
    painter->setFont(textFont);
    qreal baselineY = rect.center().y() + painter->fontMetrics().ascent() / 3.0;
    for (int i = 0; i < charCount; i++) {
        painter->setPen(QPen(QColor(randInt(180), randInt(180), randInt(180))));
        QString ch = QString(_code[i]);
        qreal textWidth = painter->fontMetrics().horizontalAdvance(ch);
        qreal x = i * charWidth + (charWidth - textWidth) / 2;
        qreal y = baselineY + randReal(rect.height() * -0.1, rect.height() * 0.1);
        painter->drawText(QPointF(x, y), ch);
    }
    painter->restore();
}

void FluCaptcha::refresh() {
    this->_code.clear();
    for (int i = 0; i < 4; ++i) {
        int num = randInt(3);
        if (num == 0) {
            this->_code += QString::number(randInt(10));
        } else if (num == 1) {
            int temp = 'A';
            this->_code += static_cast<QChar>(temp + randInt(26));
        } else if (num == 2) {
            int temp = 'a';
            this->_code += static_cast<QChar>(temp + randInt(26));
        }
    }
    update();
}

[[maybe_unused]] bool FluCaptcha::verify(const QString &code) {
    if (_ignoreCase) {
        return this->_code.toUpper() == code.toUpper();
    }
    return this->_code == code;
}
