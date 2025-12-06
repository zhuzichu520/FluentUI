#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

/**
 * @brief The FluCaptcha class
 */
class FluCaptcha : public QQuickPaintedItem {
    Q_OBJECT

    Q_PROPERTY_AUTO(QFont, font)
    Q_PROPERTY_AUTO(bool, ignoreCase)
    Q_PROPERTY_AUTO(int, noiseCount)
    Q_PROPERTY_AUTO(qreal, noiseRadius)
    Q_PROPERTY_AUTO(int, lineCount)
    Q_PROPERTY_AUTO(qreal, lineWidthMin)
    Q_PROPERTY_AUTO(qreal, lineWidthMax)

    QML_NAMED_ELEMENT(FluCaptcha)

public:
    explicit FluCaptcha(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    Q_INVOKABLE void refresh();

    [[maybe_unused]] Q_INVOKABLE bool verify(const QString &code);

private:
    QString _code;
};
