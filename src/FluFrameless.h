#ifndef FLUFRAMELESS_H
#define FLUFRAMELESS_H

#include <QObject>
#include <QQuickWindow>
#include <QtQml/qqml.h>
#include <QAbstractNativeEventFilter>
#include "stdafx.h"

class FluFrameless : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluFrameless)
public:
    explicit FluFrameless(QObject *parent = nullptr);
    ~FluFrameless();
    void classBegin() override;
    void componentComplete() override;
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
private:
    void updateCursor(int edges);
private:
    QPointer<QQuickWindow> _window = nullptr;
};

#endif // FLUFRAMELESS_H
