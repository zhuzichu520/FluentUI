#ifndef FLUFRAMELESS_H
#define FLUFRAMELESS_H

#include <QObject>
#include <QQuickWindow>
#include <QtQml/qqml.h>
#include <QAbstractNativeEventFilter>
#include "stdafx.h"

#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
using QT_NATIVE_EVENT_RESULT_TYPE = qintptr;
using QT_ENTER_EVENT_TYPE = QEnterEvent;
#else
using QT_NATIVE_EVENT_RESULT_TYPE = long;
using QT_ENTER_EVENT_TYPE = QEvent;
#endif

class FramelessEventFilter : public QAbstractNativeEventFilter
{
public:
    FramelessEventFilter(QQuickWindow* window);
    bool nativeEventFilter(const QByteArray &eventType, void *message, QT_NATIVE_EVENT_RESULT_TYPE *result) override;
public:
    QQuickWindow* _window = nullptr;
    qint64 _current = 0;
};

class FluFrameless : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluFrameless)
public:
    explicit FluFrameless(QObject *parent = nullptr);
    ~FluFrameless();
    void classBegin() override;
    void componentComplete() override;
    Q_INVOKABLE void refresLayout();
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
private:
    void updateCursor(Qt::Edges edges);
private:
    QPointer<QQuickWindow> _window = nullptr;
    FramelessEventFilter* _nativeEvent = nullptr;
};

#endif // FLUFRAMELESS_H
