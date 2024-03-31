#ifndef FLUFRAMELESS_H
#define FLUFRAMELESS_H

#include <QObject>
#include <QQuickItem>
#include <QAbstractNativeEventFilter>
#include "stdafx.h"

#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
using QT_NATIVE_EVENT_RESULT_TYPE = qintptr;
using QT_ENTER_EVENT_TYPE = QEnterEvent;
#else
using QT_NATIVE_EVENT_RESULT_TYPE = long;
using QT_ENTER_EVENT_TYPE = QEvent;
#endif


class FluFrameless : public QQuickItem,QAbstractNativeEventFilter
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QQuickItem*,appbar)
    Q_PROPERTY_AUTO(bool,topmost)
    Q_PROPERTY_AUTO(QQuickItem*,maximizeButton)
    Q_PROPERTY_AUTO(QQuickItem*,minimizedButton)
    Q_PROPERTY_AUTO(QQuickItem*,closeButton)
    Q_PROPERTY_AUTO(bool,disabled)
    Q_PROPERTY_AUTO(bool,fixSize)
    QML_NAMED_ELEMENT(FluFrameless)
public:
    explicit FluFrameless(QQuickItem* parent = nullptr);
    ~FluFrameless();
    void componentComplete() override;
    bool nativeEventFilter(const QByteArray &eventType, void *message, QT_NATIVE_EVENT_RESULT_TYPE *result) override;
    Q_INVOKABLE void showFullScreen();
    Q_INVOKABLE void showMaximized();
    Q_INVOKABLE void showMinimized();
    Q_INVOKABLE void showNormal();
    Q_INVOKABLE void setHitTestVisible(QQuickItem*);
    Q_INVOKABLE void onDestruction();
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
private:
    bool _isFullScreen();
    bool _isMaximized();
    void _updateCursor(int edges);
    void _setWindowTopmost(bool topmost);
    void _showSystemMenu(QPoint point);
    bool _containsCursorToItem(QQuickItem* item);
    bool _hitAppBar();
    bool _hitMaximizeButton();
    void _setMaximizePressed(bool val);
    void _setMaximizeHovered(bool val);
private:
    qint64 _current;
    int _edges = 0;
    int _margins = 8;
    QList<QPointer<QQuickItem>> _hitTestList;
};

#endif // FLUFRAMELESS_H
