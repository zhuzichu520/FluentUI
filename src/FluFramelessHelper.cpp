#include "FluFramelessHelper.h"

#include <QGuiApplication>
#include <QScreen>
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
    return true;
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
        bool isMax = IsZoomed(hwnd);
        offsetXY = QPoint(abs(clientRect->left - originalLeft),abs(clientRect->top - originalTop));
        if(isCompositionEnabled()){
            if(isMax){
                _helper->setOriginalPos(QPoint(originalLeft,originalTop));
                offsetSize = 0;
            }else{
                _helper->setOriginalPos({});
                offsetSize = 1;
            }
        }else{
            offsetSize = 0;
        }
        clientRect->top = originalTop+offsetSize;
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
        clientRect->bottom = originalBottom-offsetSize;
        clientRect->left = originalLeft+offsetSize;
        clientRect->right = originalRight-offsetSize;
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
    }else if(uMsg == WM_NCPAINT || uMsg == 0x00AE || uMsg == 0x00AF){
        *result = FALSE;
        return true;
    }else if(uMsg == WM_NCACTIVATE){
        *result = DefWindowProcW(hwnd, WM_NCACTIVATE, wParam, -1);
        return true;
    }else if(uMsg == WM_GETMINMAXINFO){
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
        MINMAXINFO* minmaxInfo = reinterpret_cast<MINMAXINFO *>(lParam);
        auto pixelRatio = _helper->window->devicePixelRatio();
        auto geometry = _helper->window->screen()->availableGeometry();
        minmaxInfo->ptMaxSize.x = geometry.width()*pixelRatio + offsetXY.x()*2;
        minmaxInfo->ptMaxSize.y = geometry.height()*pixelRatio + offsetXY.y()*2;
#endif
        return false;
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

        static int edges = 0;
        const int margin = 8;
        switch (ev->type()) {
        case QEvent::MouseButtonPress:
            if(edges!=0){
                QMouseEvent *event = static_cast<QMouseEvent*>(ev);
                if(event->button() == Qt::LeftButton){
                    _updateCursor(edges);
                    window->startSystemResize(Qt::Edges(edges));
                }
            }
            break;
        case QEvent::MouseButtonRelease:
            edges = 0;
            _updateCursor(edges);
            break;
        case QEvent::MouseMove: {
            if(_maximized() || _fullScreen()){
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
            if(p.x() >= margin && p.x() <= (window->width() - margin) && p.y() >= margin && p.y() <= (window->height() - margin)){
                if(edges != 0){
                    edges = 0;
                    _updateCursor(edges);
                }
                break;
            }
            edges = 0;
            if ( p.x() < margin ) {
                edges |= Qt::LeftEdge;
            }
            if ( p.x() > (window->width() - margin) ) {
                edges |= Qt::RightEdge;
            }
            if ( p.y() < margin ) {
                edges |= Qt::TopEdge;
            }
            if ( p.y() > (window->height() - margin) ) {
                edges |= Qt::BottomEdge;
            }
            _updateCursor(edges);
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
    while (nullptr != o) {
        window = (QQuickWindow*)o;
        o = o->parent();
    }
    if(!window.isNull()){
        _stayTop = QQmlProperty(window,"stayTop");
        _screen = QQmlProperty(window,"screen");
        _fixSize = QQmlProperty(window,"fixSize");
        _originalPos = QQmlProperty(window,"_originalPos");
        _realHeight = QQmlProperty(window,"_realHeight");
        _realWidth = QQmlProperty(window,"_realWidth");
        _appBarHeight = QQmlProperty(window,"_appBarHeight");
#ifdef Q_OS_WIN
        window->setFlag(Qt::CustomizeWindowHint,true);
        _nativeEvent =new FramelessEventFilter(this);
        qApp->installNativeEventFilter(_nativeEvent);
        HWND hwnd = reinterpret_cast<HWND>(window->winId());
        DWORD style = ::GetWindowLong(hwnd, GWL_STYLE);
        if(resizeable()){
            SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_MAXIMIZEBOX | WS_THICKFRAME);
        }else{
            SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_THICKFRAME);
        }
        SetWindowPos(hwnd,nullptr,0,0,0,0,SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
#else
        window->setFlags((window->flags() & (~Qt::WindowMinMaxButtonsHint) & (~Qt::Dialog)) | Qt::FramelessWindowHint | Qt::Window);
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
        window->installEventFilter(this);
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
    DeleteMenu(hMenu, SC_MOVE, MF_BYCOMMAND);
    DeleteMenu(hMenu, SC_SIZE, MF_BYCOMMAND);
    if(_maximized() || _fullScreen()){
        EnableMenuItem(hMenu,SC_RESTORE,MFS_ENABLED);
    }else{
        EnableMenuItem(hMenu,SC_RESTORE,MFS_DISABLED);
    }
    if(resizeable() && !_maximized() && !_fullScreen()){
        EnableMenuItem(hMenu,SC_MAXIMIZE,MFS_ENABLED);
    }else{
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
    QVariant appBar = window->property("appBar");
    if(appBar.isNull()){
        return false;
    }
    QVariant var;
    QMetaObject::invokeMethod(appBar.value<QObject*>(), "maximizeButtonHover",Q_RETURN_ARG(QVariant, var));
    if(var.isNull()){
        return false;
    }
    return var.toBool();
}

QObject* FluFramelessHelper::maximizeButton(){
    QVariant appBar = window->property("appBar");
    if(appBar.isNull()){
        return nullptr;
    }
    QVariant var;
    QMetaObject::invokeMethod(appBar.value<QObject*>(), "maximizeButton",Q_RETURN_ARG(QVariant, var));
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

bool FluFramelessHelper::_maximized(){
    return window->visibility() == QWindow::Maximized;
}

bool FluFramelessHelper::_fullScreen(){
    return window->visibility() == QWindow::FullScreen;
}
