#ifndef FLUFRAMELESSHELPER_H
#define FLUFRAMELESSHELPER_H

#include <QObject>
#include <QQuickWindow>
#include <QtQml/qqml.h>
#include <QAbstractNativeEventFilter>
#include <QQmlProperty>

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

class FluFramelessHelper : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluFramelessHelper)
public:
    explicit FluFramelessHelper(QObject *parent = nullptr);
    ~FluFramelessHelper();
    void classBegin() override;
    void componentComplete() override;
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
private:
    void updateCursor(int edges);
    Q_SLOT void _onStayTopChange();
    Q_SLOT void _onScreenChanged();
private:
    QPointer<QQuickWindow> _window = nullptr;
    FramelessEventFilter* _nativeEvent = nullptr;
    QQmlProperty _stayTop;
    QQmlProperty _screen;
};

#endif // FLUFRAMELESSHELPER_H
