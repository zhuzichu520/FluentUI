#include "FluFramelessHelper.h"

#include <QGuiApplication>
#include <QScreen>
#include <QQuickItem>
#include "FluTools.h"

#ifdef Q_OS_WIN
#pragma comment (lib,"user32.lib")
#pragma comment (lib,"dwmapi.lib")
#include <windows.h>
#include <windowsx.h>
#include <dwmapi.h>

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

FramelessEventFilter::FramelessEventFilter(FluFramelessHelper* helper){
    _helper = helper;
    _current = _helper->window->winId();
}

bool FramelessEventFilter::nativeEventFilter(const QByteArray &eventType, void *message, QT_NATIVE_EVENT_RESULT_TYPE *result){
#ifdef Q_OS_WIN
    if ((eventType != qtNativeEventType()) || !message || _helper.isNull() || _helper->window.isNull()) {
        return false;
    }
    const auto msg = static_cast<const MSG *>(message);
    const HWND hwnd = msg->hwnd;
    if (!hwnd || !msg) {
        return false;
    }
    const qint64 wid = reinterpret_cast<qint64>(hwnd);
    if(wid != _current){
        return false;
    }
    const UINT uMsg = msg->message;
    const WPARAM wParam = msg->wParam;
    const LPARAM lParam = msg->lParam;
    static QPoint offsetXY;
    if(uMsg == WM_WINDOWPOSCHANGING){
        WINDOWPOS* wp = reinterpret_cast<WINDOWPOS*>(lParam);
        if (wp != nullptr && (wp->flags & SWP_NOSIZE) == 0)
        {
            wp->flags |= SWP_NOCOPYBITS;
            *result = DefWindowProcW(hwnd, uMsg, wParam, lParam);
            return true;
        }
        return false;
    }else if(uMsg == WM_NCCALCSIZE){
        const auto clientRect = ((wParam == FALSE) ? reinterpret_cast<LPRECT>(lParam) : &(reinterpret_cast<LPNCCALCSIZE_PARAMS>(lParam))->rgrc[0]);
        const LONG originalTop = clientRect->top;
        const LONG originalLeft = clientRect->left;
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
        const LONG originalRight = clientRect->right;
        const LONG originalBottom = clientRect->bottom;
#endif
        const LRESULT hitTestResult = ::DefWindowProcW(hwnd, WM_NCCALCSIZE, wParam, lParam);
        if ((hitTestResult != HTERROR) && (hitTestResult != HTNOWHERE)) {
            *result = hitTestResult;
            return true;
        }
        int offsetSize = 0;
        bool isMaximum = IsZoomed(hwnd);
        offsetXY = QPoint(abs(clientRect->left - originalLeft),abs(clientRect->top - originalTop));
        if(isMaximum || _helper->fullScreen()){
            _helper->setOriginalPos(QPoint(originalLeft,originalTop));
            offsetSize = 0;
        }else{
            _helper->setOriginalPos({});
            offsetSize = 1;
        }
        if(!isCompositionEnabled()){
            offsetSize = 0;
        }
        clientRect->top = originalTop+offsetSize;
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
        if(!isMaximum){
            clientRect->bottom = originalBottom-offsetSize;
            clientRect->left = originalLeft+offsetSize;
            clientRect->right = originalRight-offsetSize;
        }
#endif
        *result = WVR_REDRAW;
        return true;
    }if(uMsg == WM_NCHITTEST){
        if(FluTools::getInstance()->isWindows11OrGreater() && _helper->hoverMaxBtn() && _helper->resizeable()){
            if (*result == HTNOWHERE) {
                *result = HTZOOM;
            }
            return true;
        }
        *result = 0;
        short x = LOWORD(msg->lParam);
        short y = HIWORD(msg->lParam);
        int margins = _helper->getMargins();
        QPointer<QQuickWindow> win = _helper->window;
        qreal dp = _helper->window->devicePixelRatio();
        QPoint pos =  win->mapFromGlobal(QPoint(x/dp, y/dp));
        bool left = pos.x() < margins;
        bool right = pos.x() > win->width() - margins;
        bool top = pos.y() < margins;
        bool bottom = pos.y() > win->height() - margins;
        *result = 0;
        if (_helper->resizeable() && !_helper->fullScreen() && !_helper->maximized()) {
            if (left && top) {
                *result = HTTOPLEFT;
            } else if (left && bottom) {
                *result = HTBOTTOMLEFT;
            } else if (right && top) {
                *result = HTTOPRIGHT;
            } else if (right && bottom) {
                *result = HTBOTTOMRIGHT;
            } else if (left) {
                *result = HTLEFT;
            } else if (right) {
                *result = HTRIGHT;
            } else if (top) {
                *result = HTTOP;
            } else if (bottom) {
                *result = HTBOTTOM;
            }
        }
        if (0 != *result) {
            return true;
        }
        QVariant appBar = _helper->getAppBar();
        if(!appBar.isNull()){
            auto item = appBar.value<QQuickItem*>();
            if(item->contains(pos)){
                QPoint appBarTopLeft = item->mapToItem(_helper->window->contentItem(),QPoint(0, 0)).toPoint();
                QRect rcAppBar = QRect(appBarTopLeft, QSize(item->width(), item->height()));
                if (rcAppBar.contains(pos) && _helper->hoverAppBar())
                {
                    *result = HTCAPTION;
                    return true;
                }
            }
        }
        *result = HTCLIENT;
        return true;
    }else if(uMsg == WM_NCLBUTTONDBLCLK || uMsg == WM_NCLBUTTONDOWN){
        if(FluTools::getInstance()->isWindows11OrGreater() && _helper->hoverMaxBtn() && _helper->resizeable()){
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonPress, QPoint(), QPoint(), Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(_helper->maximizeButton(),&event);
            return true;
        }
        return false;
    }else if(uMsg == WM_NCLBUTTONUP || uMsg == WM_NCRBUTTONUP){
        if(FluTools::getInstance()->isWindows11OrGreater() && _helper->hoverMaxBtn() && _helper->resizeable()){
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonRelease, QPoint(), QPoint(), Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(_helper->maximizeButton(),&event);
        }
        return false;
    }else if(uMsg == WM_NCPAINT){
        *result = FALSE;
        return true;
    }else if(uMsg == WM_NCACTIVATE){
        *result = DefWindowProcW(hwnd, WM_NCACTIVATE, wParam, -1);
        return true;
    }else if(uMsg == WM_GETMINMAXINFO){
#if QT_VERSION < QT_VERSION_CHECK(6,2,4)
        MINMAXINFO* minmaxInfo = reinterpret_cast<MINMAXINFO *>(lParam);
        auto pixelRatio = _helper->window->devicePixelRatio();
        auto geometry = _helper->window->screen()->availableGeometry();
        minmaxInfo->ptMaxSize.x = geometry.width()*pixelRatio + offsetXY.x()*2;
        minmaxInfo->ptMaxSize.y = geometry.height()*pixelRatio + offsetXY.y()*2;
#endif
        return false;
    }else if(uMsg == WM_NCRBUTTONDOWN){
        if (wParam == HTCAPTION) {
            _helper->showSystemMenu();
        }
    }
    return false;
#endif
    return false;
}

FluFramelessHelper::FluFramelessHelper(QObject *parent)
    : QObject{parent}
{

}

void FluFramelessHelper::classBegin(){
}

void FluFramelessHelper::_updateCursor(int edges){
    switch (edges) {
    case 0:
        window->setCursor(Qt::ArrowCursor);
        break;
    case Qt::LeftEdge:
    case Qt::RightEdge:
        window->setCursor(Qt::SizeHorCursor);
        break;
    case Qt::TopEdge:
    case Qt::BottomEdge:
        window->setCursor(Qt::SizeVerCursor);
        break;
    case Qt::LeftEdge | Qt::TopEdge:
    case Qt::RightEdge | Qt::BottomEdge:
        window->setCursor(Qt::SizeFDiagCursor);
        break;
    case Qt::RightEdge | Qt::TopEdge:
    case Qt::LeftEdge | Qt::BottomEdge:
        window->setCursor(Qt::SizeBDiagCursor);
        break;
    }
}

bool FluFramelessHelper::eventFilter(QObject *obj, QEvent *ev){
    if (!window.isNull() && window->flags()) {
        switch (ev->type()) {
        case QEvent::MouseButtonPress:
            if(_edges!=0){
                QMouseEvent *event = static_cast<QMouseEvent*>(ev);
                if(event->button() == Qt::LeftButton){
                    _updateCursor(_edges);
                    window->startSystemResize(Qt::Edges(_edges));
                }
            }
            break;
        case QEvent::MouseButtonRelease:
            _edges = 0;
            break;
        case QEvent::MouseMove: {
            if(maximized() || fullScreen()){
                break;
            }
            if(!resizeable()){
                break;
            }
            QMouseEvent *event = static_cast<QMouseEvent*>(ev);
            QPoint p =
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
                event->pos();
#else
                event->position().toPoint();
#endif
            if(p.x() >= _margins && p.x() <= (window->width() - _margins) && p.y() >= _margins && p.y() <= (window->height() - _margins)){
                if(_edges != 0){
                    _edges = 0;
                    _updateCursor(_edges);
                }
                break;
            }
            _edges = 0;
            if ( p.x() < _margins ) {
                _edges |= Qt::LeftEdge;
            }
            if ( p.x() > (window->width() - _margins) ) {
                _edges |= Qt::RightEdge;
            }
            if ( p.y() < _margins ) {
                _edges |= Qt::TopEdge;
            }
            if ( p.y() > (window->height() - _margins) ) {
                _edges |= Qt::BottomEdge;
            }
            _updateCursor(_edges);
            break;
        }
        default:
            break;
        }
    }
    return QObject::eventFilter(obj, ev);
}

void FluFramelessHelper::componentComplete(){
    auto o = parent();
    do {
        window = qobject_cast<QQuickWindow *>(o);
        if (window) {
            break;
        }
        o = o->parent();
    } while (nullptr != o);
    if(!window.isNull()){
        _stayTop = QQmlProperty(window,"stayTop");
        _screen = QQmlProperty(window,"screen");
        _fixSize = QQmlProperty(window,"fixSize");
        _originalPos = QQmlProperty(window,"_originalPos");
        _realHeight = QQmlProperty(window,"_realHeight");
        _realWidth = QQmlProperty(window,"_realWidth");
        _appBarHeight = QQmlProperty(window,"_appBarHeight");
        _appBar = window->property("appBar");
#ifdef Q_OS_WIN
        if(!_appBar.isNull()){
            _appBar.value<QObject*>()->setProperty("systemMoveEnable",false);
        }
        window->setFlags((window->flags()) | Qt::CustomizeWindowHint | Qt::WindowMinimizeButtonHint);
        _nativeEvent =new FramelessEventFilter(this);
        qApp->installNativeEventFilter(_nativeEvent);
        HWND hwnd = reinterpret_cast<HWND>(window->winId());
        DWORD style = ::GetWindowLong(hwnd, GWL_STYLE);
        if(resizeable()){
            SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_MAXIMIZEBOX | WS_THICKFRAME);
        }else{
            SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_THICKFRAME);
        }
        LONG exstyle = ::GetWindowLong(hwnd, GWL_EXSTYLE);
        exstyle = exstyle | WS_EX_LAYERED;
        SetWindowLongPtr(hwnd, GWL_EXSTYLE, exstyle);
        SetLayeredWindowAttributes(hwnd, RGB(251, 255, 242), 0, LWA_COLORKEY);
        connect(window,&QQuickWindow::activeChanged,this,[this,hwnd]{
            if(this->window->isActive()){
                LONG exstyle = ::GetWindowLong(hwnd, GWL_EXSTYLE);
                if(exstyle & WS_EX_LAYERED){
                    exstyle = exstyle &~ WS_EX_LAYERED;
                    SetWindowLongPtr(hwnd, GWL_EXSTYLE, exstyle);
                    SetWindowPos(hwnd,nullptr,0,0,0,0,SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
                }
            }
        });
#else
        window->setFlags((window->flags() & (~Qt::WindowMinMaxButtonsHint) & (~Qt::Dialog)) | Qt::FramelessWindowHint | Qt::Window);
        window->installEventFilter(this);
#endif
        int w = _realWidth.read().toInt();
        int h = _realHeight.read().toInt()+_appBarHeight.read().toInt();
        if(!resizeable()){
            window->setMaximumSize(QSize(w,h));
            window->setMinimumSize(QSize(w,h));
        }
        window->setWidth(w);
        window->setHeight(h);
        _onStayTopChange();
        _stayTop.connectNotifySignal(this,SLOT(_onStayTopChange()));
        _screen.connectNotifySignal(this,SLOT(_onScreenChanged()));
        Q_EMIT loadCompleted();
    }
}

void FluFramelessHelper::_onScreenChanged(){
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window->winId());
    SetWindowPos(hwnd,0,0,0,0,0,SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOOWNERZORDER);
    RedrawWindow(hwnd, NULL, NULL, RDW_INVALIDATE | RDW_UPDATENOW);
#endif
}

void FluFramelessHelper::showSystemMenu(){
#ifdef Q_OS_WIN
    QPoint point = QCursor::pos();
    HWND hwnd = reinterpret_cast<HWND>(window->winId());
    DWORD style = GetWindowLongPtr(hwnd,GWL_STYLE);
    SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_SYSMENU);
    const HMENU hMenu = ::GetSystemMenu(hwnd, FALSE);
    if(maximized() || fullScreen()){
        EnableMenuItem(hMenu,SC_MOVE,MFS_DISABLED);
        EnableMenuItem(hMenu,SC_RESTORE,MFS_ENABLED);
    }else{
        EnableMenuItem(hMenu,SC_MOVE,MFS_ENABLED);
        EnableMenuItem(hMenu,SC_RESTORE,MFS_DISABLED);
    }
    if(resizeable() && !maximized() && !fullScreen()){
        EnableMenuItem(hMenu,SC_SIZE,MFS_ENABLED);
        EnableMenuItem(hMenu,SC_MAXIMIZE,MFS_ENABLED);
    }else{
        EnableMenuItem(hMenu,SC_SIZE,MFS_DISABLED);
        EnableMenuItem(hMenu,SC_MAXIMIZE,MFS_DISABLED);
    }
    const int result = TrackPopupMenu(hMenu, (TPM_RETURNCMD | (QGuiApplication::isRightToLeft() ? TPM_RIGHTALIGN : TPM_LEFTALIGN)), point.x()*window->devicePixelRatio(), point.y()*window->devicePixelRatio(), 0, hwnd, nullptr);
    if (result != FALSE) {
        PostMessageW(hwnd, WM_SYSCOMMAND, result, 0);
    }
    SetWindowLongPtr(hwnd, GWL_STYLE, style &~ WS_SYSMENU);
#endif
}

void FluFramelessHelper::_onStayTopChange(){
    bool isStayTop = _stayTop.read().toBool();
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window->winId());
    if(isStayTop){
        SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    }else{
        SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    }
#else
    window->setFlag(Qt::WindowStaysOnTopHint,isStayTop);
#endif
}

FluFramelessHelper::~FluFramelessHelper(){
    if (!window.isNull()) {
        window->setFlags(Qt::Window);
#ifdef Q_OS_WIN
        qApp->removeNativeEventFilter(_nativeEvent);
        delete _nativeEvent;
#endif
        window->removeEventFilter(this);
    }
}

bool FluFramelessHelper::hoverMaxBtn(){
    if(_appBar.isNull()){
        return false;
    }
    QVariant var;
    QMetaObject::invokeMethod(_appBar.value<QObject*>(), "_maximizeButtonHover",Q_RETURN_ARG(QVariant, var));
    if(var.isNull()){
        return false;
    }
    return var.toBool();
}

bool FluFramelessHelper::hoverAppBar(){
    if(_appBar.isNull()){
        return false;
    }
    QVariant var;
    QMetaObject::invokeMethod(_appBar.value<QObject*>(), "_appBarHover",Q_RETURN_ARG(QVariant, var));
    if(var.isNull()){
        return false;
    }
    return var.toBool();
}

QVariant FluFramelessHelper::getAppBar(){
    return _appBar;
}

QObject* FluFramelessHelper::maximizeButton(){
    if(_appBar.isNull()){
        return nullptr;
    }
    QVariant var = _appBar.value<QObject*>()->property("buttonMaximize");
    if(var.isNull()){
        return nullptr;
    }
    return var.value<QObject*>();
}

void FluFramelessHelper::setOriginalPos(QVariant pos){
    _originalPos.write(pos);
}

bool FluFramelessHelper::resizeable(){
    return !_fixSize.read().toBool();
}

bool FluFramelessHelper::maximized(){
    return window->visibility() == QWindow::Maximized;
}

bool FluFramelessHelper::fullScreen(){
    return window->visibility() == QWindow::FullScreen;
}

int FluFramelessHelper::getMargins(){
    return _margins;
}
