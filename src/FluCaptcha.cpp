#include "FluCaptcha.h"
#include <QTime>
#include <QChar>
#include <QPainter>
#include <QRandomGenerator>

int generaNumber(int number) {
    return QRandomGenerator::global()->bounded(0, number);
}

FluCaptcha::FluCaptcha(QQuickItem *parent) : QQuickPaintedItem(parent) {
    _ignoreCase = false;
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
}

void FluCaptcha::paint(QPainter *painter) {
    painter->save();
    painter->fillRect(boundingRect().toRect(), QColor(255, 255, 255, 255));
    QPen pen;
    painter->setFont(_font);
    for (int i = 0; i < 100; i++) {
        pen = QPen(QColor(generaNumber(256), generaNumber(256), generaNumber(256)));
        painter->setPen(pen);
        painter->drawPoint(generaNumber(180), generaNumber(80));
    }
    for (int i = 0; i < 5; i++) {
        pen = QPen(QColor(generaNumber(256), generaNumber(256), generaNumber(256)));
        painter->setPen(pen);
        painter->drawLine(generaNumber(180), generaNumber(80), generaNumber(180), generaNumber(80));
    }
    for (int i = 0; i < 4; i++) {
        pen = QPen(QColor(generaNumber(255), generaNumber(255), generaNumber(255)));
        painter->setPen(pen);
        painter->drawText(15 + 35 * i, 10 + generaNumber(15), 30, 40, Qt::AlignCenter,
                          QString(_code[i]));
    }
    painter->restore();
}

void FluCaptcha::refresh() {
    this->_code.clear();
    for (int i = 0; i < 4; ++i) {
        int num = generaNumber(3);
        if (num == 0) {
            this->_code += QString::number(generaNumber(10));
        } else if (num == 1) {
            int temp = 'A';
            this->_code += static_cast<QChar>(temp + generaNumber(26));
        } else if (num == 2) {
            int temp = 'a';
            this->_code += static_cast<QChar>(temp + generaNumber(26));
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
