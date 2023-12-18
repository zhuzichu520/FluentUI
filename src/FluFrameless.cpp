#include "FluFrameless.h"

#include <QGuiApplication>
#include <QOperatingSystemVersion>
#ifdef Q_OS_WIN
#pragma comment(lib, "user32.lib")
#include <windows.h>
static inline QByteArray qtNativeEventType()
{
    static const auto result = "windows_generic_MSG";
    return result;
}
static inline bool isCompositionEnabled(){
    typedef HRESULT (WINAPI* DwmIsCompositionEnabledPtr)(BOOL *pfEnabled);
    HMODULE module = LoadLibraryW(L"dwmapi.dll");
    if (module)
    {
        BOOL composition_enabled = false;
        DwmIsCompositionEnabledPtr dwm_is_composition_enabled;
        dwm_is_composition_enabled= reinterpret_cast<DwmIsCompositionEnabledPtr>(GetProcAddress(module, "DwmIsCompositionEnabled"));
        if (dwm_is_composition_enabled)
        {
            dwm_is_composition_enabled(&composition_enabled);
        }
        return composition_enabled;
    }
    return false;
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
    const HWND hwnd = msg->hwnd;
    if (!hwnd) {
        return false;
    }
    const qint64 wid = reinterpret_cast<qint64>(hwnd);
    if(wid != _current){
        return false;
    }
    const UINT uMsg = msg->message;
    const WPARAM wParam = msg->wParam;
    const LPARAM lParam = msg->lParam;
    if (!msg || !hwnd)
    {
        return false;
    }
    if(uMsg == WM_WINDOWPOSCHANGING){
        WINDOWPOS* wp = reinterpret_cast<WINDOWPOS*>(lParam);
        if (wp != nullptr && (wp->flags & SWP_NOSIZE) == 0)
        {
            wp->flags |= SWP_NOCOPYBITS;
            *result = DefWindowProc(hwnd, uMsg, wParam, lParam);
            return true;
        }
        return false;
    }else if(uMsg == WM_NCCALCSIZE){
        *result = WVR_REDRAW;
        return true;
    }else if(uMsg == WM_NCPAINT){
        if(!isCompositionEnabled()){
            *result = WVR_REDRAW;
            return true;
        }
        return false;
    }else if(uMsg == WM_NCACTIVATE){
        if(!isCompositionEnabled()){
            *result = 1;
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
    if (!_window.isNull()) {

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
            QMouseEvent *event = static_cast<QMouseEvent*>(ev);
            QPoint p =
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
                event->pos();
#else
                event->position().toPoint();
#endif
            if(p.x() >= margin && p.x() <= (_window->width() - margin) && p.y() >= margin && p.y() <= (_window->height() - margin)){
                if(edges != 0){
                    edges = 0;
                    updateCursor(edges);
                }
                break;
            }
            edges = 0;
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
#ifdef Q_OS_WIN
        _nativeEvent =new FramelessEventFilter(_window);
        qApp->installNativeEventFilter(_nativeEvent);
        HWND hwnd = reinterpret_cast<HWND>(_window->winId());
        ULONG_PTR cNewStyle = GetClassLongPtr(hwnd, GCL_STYLE) | CS_DROPSHADOW;
        SetClassLongPtr(hwnd, GCL_STYLE, cNewStyle);
        DWORD style = GetWindowLongPtr(hwnd,GWL_STYLE);
        SetWindowLongPtr(hwnd,GWL_STYLE,style &~ WS_SYSMENU);
        SetWindowPos(hwnd,nullptr,0,0,0,0,SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE |SWP_FRAMECHANGED);
        _stayTop = QQmlProperty(_window,"stayTop");
        _stayTop.connectNotifySignal(this,SLOT(_stayTopChange()));
#else
        _window->setFlag(Qt::FramelessWindowHint,true);
#endif
        _window->installEventFilter(this);
    }
}

void FluFrameless::_stayTopChange(){
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(_window->winId());
    DWORD style = GetWindowLongPtr(hwnd,GWL_STYLE);
    SetWindowLongPtr(hwnd,GWL_STYLE,style &~ WS_SYSMENU);
#endif
}

FluFrameless::~FluFrameless(){
    if (!_window.isNull()) {
        _window->removeEventFilter(this);
#ifdef Q_OS_WIN
        qApp->removeNativeEventFilter(_nativeEvent);
#else
        _window->setFlag(Qt::FramelessWindowHint,false);
#endif
    }
}
