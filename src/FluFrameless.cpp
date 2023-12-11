#include "FluFrameless.h"

#include "FluFrameless.h"

#include <QGuiApplication>
#include <QScreen>

#ifdef Q_OS_WIN
#pragma comment(lib, "dwmapi.lib")
#pragma comment(lib, "user32.lib")
#pragma comment(lib, "shcore.lib")
#pragma comment(lib, "Gdi32.lib")
#include <Windows.h>
#include <windowsx.h>
#include <winuser.h>
#include <dwmapi.h>
#include <codecvt>
#include <cmath>
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
    const LPARAM lParam = msg->lParam;
    const int borderPadding = 8;
    if (uMsg == WM_NCCALCSIZE) {
        if (_window->visibility() == QWindow::FullScreen) {
            NCCALCSIZE_PARAMS* sz = reinterpret_cast<NCCALCSIZE_PARAMS*>(lParam);
            sz->rgrc[0].left += borderPadding;
            sz->rgrc[0].top += borderPadding;
            sz->rgrc[0].right -= borderPadding;
            sz->rgrc[0].bottom -= borderPadding;
            *result = WVR_REDRAW;
            return true;
        }
        NCCALCSIZE_PARAMS* sz = reinterpret_cast<NCCALCSIZE_PARAMS*>(lParam);
        if ( _window->visibility() == QWindow::Maximized) {
            sz->rgrc[0].top += borderPadding;
        } else {
            sz->rgrc[0].top += 0;
        }
        sz->rgrc[0].right -= borderPadding;
        sz->rgrc[0].bottom -= borderPadding;
        sz->rgrc[0].left -= -borderPadding;
        *result = WVR_REDRAW;
        return true;
    }else if (uMsg == WM_NCHITTEST){
        const bool isResizable  = !(_window->height()==_window->maximumHeight()&&_window->height()==_window->minimumHeight()&&_window->width()==_window->maximumWidth()&&_window->width()==_window->minimumWidth());
        RECT winrect;
        GetWindowRect(msg->hwnd, &winrect);
        long x = GET_X_LPARAM(msg->lParam);
        long y = GET_Y_LPARAM(msg->lParam);
        if (x >= winrect.left && x < winrect.left + borderPadding &&
            y < winrect.bottom && y >= winrect.bottom - borderPadding && isResizable) {
            *result = HTBOTTOMLEFT;
            return true;
        }
        if (x < winrect.right && x >= winrect.right - borderPadding &&
            y < winrect.bottom && y >= winrect.bottom - borderPadding && isResizable) {
            *result = HTBOTTOMRIGHT;
            return true;
        }
        if (x >= winrect.left && x < winrect.left + borderPadding &&
            y >= winrect.top && y < winrect.top + borderPadding && isResizable) {
            *result = HTTOPLEFT;
            return true;
        }
        if (x < winrect.right && x >= winrect.right - borderPadding &&
            y >= winrect.top && y < winrect.top + borderPadding && isResizable) {
            *result = HTTOPRIGHT;
            return true;
        }
        if (x >= winrect.left && x < winrect.left + borderPadding && isResizable) {
            *result = HTLEFT;
            return true;
        }
        if (x < winrect.right && x >= winrect.right - borderPadding && isResizable) {
            *result = HTRIGHT;
            return true;
        }
        if (y < winrect.bottom && y >= winrect.bottom - borderPadding && isResizable) {
            *result = HTBOTTOM;
            return true;
        }
        if (y >= winrect.top && y < winrect.top + borderPadding && isResizable) {
            *result = HTTOP;
            return true;
        }
        return false;
    }else if(uMsg == WM_COMMAND){
        SendMessage(msg->hwnd, WM_SYSCOMMAND, msg->wParam, msg->lParam);
        *result = DefWindowProc(msg->hwnd, msg->message, msg->wParam, msg->lParam);
        return true;
    }else if(uMsg == WM_WINDOWPOSCHANGING){
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

void FluFrameless::refresLayout(){
#ifdef Q_OS_WIN
    if(!_window.isNull()){
        HWND hWnd = reinterpret_cast<HWND>(_window->winId());
        RECT rect;
        GetWindowRect(hWnd, &rect);
        SetWindowPos(hWnd, nullptr, rect.left, rect.top, rect.right - rect.left,rect.bottom - rect.top,SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE |SWP_FRAMECHANGED);
    }
#endif
}

void FluFrameless::updateCursor(Qt::Edges edges){
    switch (edges) {
    case 0:
        _window->setCursor(Qt::ArrowCursor);
        break;
    case Qt::LeftEdge:
    case Qt::RightEdge:
        _window->setCursor(Qt::SizeHorCursor);
        break;
    case Qt::TopEdge:
    case Qt::BottomEdge:
        _window->setCursor(Qt::SizeVerCursor);
        break;
    case Qt::LeftEdge | Qt::TopEdge:
    case Qt::RightEdge | Qt::BottomEdge:
        _window->setCursor(Qt::SizeFDiagCursor);
        break;
    case Qt::RightEdge | Qt::TopEdge:
    case Qt::LeftEdge | Qt::BottomEdge:
        _window->setCursor(Qt::SizeBDiagCursor);
        break;
    }
}

bool FluFrameless::eventFilter(QObject *obj, QEvent *ev){
    if (_window->flags()& Qt::FramelessWindowHint) {
        static Qt::Edges edges = Qt::Edges();
        const int margin = 8;
        switch (ev->type()) {
        case QEvent::MouseButtonPress:
            updateCursor(edges);
            _window->startSystemResize(edges);
            break;
        case QEvent::MouseButtonRelease:
            qDebug() << Q_FUNC_INFO << ev;
            edges = Qt::Edges();
            updateCursor(edges);
            break;
        case QEvent::MouseMove: {
            edges = Qt::Edges();
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
#ifdef Q_OS_WIN
    if(!_window.isNull()){
        _nativeEvent =new FramelessEventFilter(_window);
        qApp->installNativeEventFilter(_nativeEvent);
        //        MARGINS margins[2]{{0, 0, 0, 0}, {0, 0, 1, 0}};
        //        HWND hWnd = reinterpret_cast<HWND>(_window->winId());
        //        DwmExtendFrameIntoClientArea(hWnd, &margins[false]);
        refresLayout();
        connect(_window,&QWindow::visibilityChanged,this,[=](QWindow::Visibility visibility){ refresLayout(); });
    }
#endif
#ifdef Q_OS_LINUX
    if(!_window.isNull()){
        _window->setFlag(Qt::FramelessWindowHint,true);
        _window->installEventFilter(this);
    }
#endif
}

FluFrameless::~FluFrameless(){
#ifdef Q_OS_WIN
    if (_nativeEvent) {
        delete _nativeEvent;
        _nativeEvent = nullptr;
        refresLayout();
    }
#endif
#ifdef Q_OS_LINUX
    if (!_window.isNull()) {
        _window->removeEventFilter(this);
        _window->setFlag(Qt::FramelessWindowHint,false);
    }
#endif
}
