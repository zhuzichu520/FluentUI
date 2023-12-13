#include "FluFrameless.h"

#include <QGuiApplication>

#ifdef Q_OS_WIN
#pragma comment(lib, "user32.lib")
#include <windows.h>
static inline QByteArray qtNativeEventType()
{
    static const auto result = "windows_generic_MSG";
    return result;
}
#endif

FramelessEventFilter::FramelessEventFilter(QQuickWindow* window){
    _window = window;
    _current = window->winId();
}

bool FramelessEventFilter::nativeEventFilter(const QByteArray &eventType, void *message, QT_NATIVE_EVENT_RESULT_TYPE *result){
#ifdef Q_OS_WIN
    if ((eventType != qtNativeEventType()) || !message || !result || !_window) {
        return false;
    }
    const auto msg = static_cast<const MSG *>(message);
    const HWND hWnd = msg->hwnd;
    if (!hWnd) {
        return false;
    }
    const qint64 wid = reinterpret_cast<qint64>(hWnd);
    if(wid != _current){
        return false;
    }
    const UINT uMsg = msg->message;
    if (!msg || !msg->hwnd)
    {
        return false;
    }
    if(uMsg == WM_WINDOWPOSCHANGING){
        WINDOWPOS* wp = reinterpret_cast<WINDOWPOS*>(msg->lParam);
        if (wp != nullptr && (wp->flags & SWP_NOSIZE) == 0)
        {
            wp->flags |= SWP_NOCOPYBITS;
            *result = DefWindowProc(msg->hwnd, msg->message, msg->wParam, msg->lParam);
            return true;
        }
        return false;
    }
    return false;
#endif
    return false;
}

FluFrameless::FluFrameless(QObject *parent)
    : QObject{parent}
{
}

void FluFrameless::classBegin(){
}

void FluFrameless::updateCursor(int edges){
    switch (edges) {
    case 0:
        qApp->restoreOverrideCursor();
        break;
    case Qt::LeftEdge:
    case Qt::RightEdge:
        qApp->setOverrideCursor(QCursor(Qt::SizeHorCursor));
        break;
    case Qt::TopEdge:
    case Qt::BottomEdge:
        qApp->setOverrideCursor(QCursor(Qt::SizeVerCursor));
        break;
    case Qt::LeftEdge | Qt::TopEdge:
    case Qt::RightEdge | Qt::BottomEdge:
        qApp->setOverrideCursor(QCursor(Qt::SizeFDiagCursor));
        break;
    case Qt::RightEdge | Qt::TopEdge:
    case Qt::LeftEdge | Qt::BottomEdge:
        qApp->setOverrideCursor(QCursor(Qt::SizeBDiagCursor));
        break;
    }
}

bool FluFrameless::eventFilter(QObject *obj, QEvent *ev){
    if (!_window.isNull() && _window->flags()& Qt::FramelessWindowHint) {
        static int edges = 0;
        const int margin = 8;
        switch (ev->type()) {
        case QEvent::MouseButtonPress:
            if(edges!=0){
                updateCursor(edges);
                _window->startSystemResize(Qt::Edges(edges));
            }
            break;
        case QEvent::MouseButtonRelease:
            edges = 0;
            updateCursor(edges);
            break;
        case QEvent::MouseMove: {
            if(_window->visibility() == QWindow::Maximized || _window->visibility() == QWindow::FullScreen){
                break;
            }
            if(_window->width() == _window->maximumWidth() && _window->width() == _window->minimumWidth() && _window->height() == _window->maximumHeight() && _window->height() == _window->minimumHeight()){
                break;
            }
            edges = 0;
            QMouseEvent *event = static_cast<QMouseEvent*>(ev);
            QPoint p =
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
                event->pos();
#else
                event->position().toPoint();
#endif
            if ( p.x() < margin ) {
                edges |= Qt::LeftEdge;
            }
            if ( p.x() > (_window->width() - margin) ) {
                edges |= Qt::RightEdge;
            }
            if ( p.y() < margin ) {
                edges |= Qt::TopEdge;
            }
            if ( p.y() > (_window->height() - margin) ) {
                edges |= Qt::BottomEdge;
            }
            updateCursor(edges);
            break;
        }
        default:
            break;
        }
    }
    return QObject::eventFilter(obj, ev);
}

void FluFrameless::componentComplete(){
    auto o = parent();
    while (nullptr != o) {
        _window = (QQuickWindow*)o;
        o = o->parent();
    }
    if(!_window.isNull()){
        _window->setFlag(Qt::FramelessWindowHint,true);
        _window->installEventFilter(this);
#ifdef Q_OS_WIN
        _nativeEvent =new FramelessEventFilter(_window);
        qApp->installNativeEventFilter(_nativeEvent);
#endif
    }
}

FluFrameless::~FluFrameless(){
    if (!_window.isNull()) {
        _window->setFlag(Qt::FramelessWindowHint,false);
        _window->removeEventFilter(this);
#ifdef Q_OS_WIN
        qApp->removeNativeEventFilter(_nativeEvent);
#endif
    }
}
