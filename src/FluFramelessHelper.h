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

class FluFramelessHelper;

/**
 * @brief The FramelessEventFilter class
 */
class FramelessEventFilter : public QAbstractNativeEventFilter
{
public:
    FramelessEventFilter(FluFramelessHelper* helper);
    bool nativeEventFilter(const QByteArray &eventType, void *message, QT_NATIVE_EVENT_RESULT_TYPE *result) override;
public:
    QPointer<FluFramelessHelper> _helper = nullptr;
    qint64 _current = 0;
};

/**
 * @brief The FluFramelessHelper class
 */
class FluFramelessHelper : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_NAMED_ELEMENT(FluFramelessHelper)
public:
    explicit FluFramelessHelper(QObject *parent = nullptr);
    ~FluFramelessHelper();
    void classBegin() override;
    void componentComplete() override;
    bool hoverMaxBtn();
    bool hoverAppBar();
    bool resizeable();
    int getMargins();
    bool maximized();
    bool fullScreen();
    int getAppBarHeight();
    QVariant getAppBar();
    QObject* maximizeButton();
    Q_INVOKABLE void showSystemMenu(QPoint point);
    Q_INVOKABLE void showMaximized();
    Q_SIGNAL void loadCompleted();
protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
private:
    void _updateCursor(int edges);
    Q_SLOT void _onStayTopChange();
    Q_SLOT void _onScreenChanged();
public:
    QPointer<QQuickWindow> window = nullptr;
private:
    FramelessEventFilter* _nativeEvent = nullptr;
    QQmlProperty _stayTop;
    QQmlProperty _screen;
    QQmlProperty _fixSize;
    QQmlProperty _realHeight;
    QQmlProperty _realWidth;
    QQmlProperty _appBarHeight;
    QVariant _appBar;
    int _edges = 0;
    int _margins = 8;
};

#endif // FLUFRAMELESSHELPER_H
