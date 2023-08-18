#ifndef FLUCAPTCHA_H
#define FLUCAPTCHA_H

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

class FluCaptcha : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QFont,font);
    QML_NAMED_ELEMENT(FluCaptcha)
private:
    int _generaNumber(int number);
    QString _code;
public:
    explicit FluCaptcha(QQuickItem *parent = nullptr);
    void paint(QPainter* painter) override;
    Q_INVOKABLE void refresh();
    Q_INVOKABLE bool verify(const QString& code);
};

#endif // FLUCAPTCHA_H
