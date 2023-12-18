#ifndef FLUFRAMELESS_H
#define FLUFRAMELESS_H

#include <QObject>
#include <QQuickWindow>
#include <QtQml/qqml.h>
#include <QAbstractNativeEventFilter>
#include <QQmlProperty>
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
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
private:
    void updateCursor(int edges);
    Q_SLOT void _stayTopChange();
private:
    QPointer<QQuickWindow> _window = nullptr;
    FramelessEventFilter* _nativeEvent = nullptr;
    QQmlProperty _stayTop;
};

#endif // FLUFRAMELESS_H
