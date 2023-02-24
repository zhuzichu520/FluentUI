#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QtQuick/QQuickPaintedItem>

class FluentUI : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_DISABLE_COPY(FluentUI)
public:
    explicit FluentUI(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;
    ~FluentUI() override;
signals:

};

#endif // FLUENTUI_H
