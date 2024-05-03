#include "FluFrameless.h"

#include <QQuickWindow>
#include <QGuiApplication>
#include <QScreen>
#include <QDateTime>
#include "FluTools.h"

#ifdef Q_OS_WIN

#pragma comment (lib, "user32.lib")
#pragma comment (lib, "dwmapi.lib")

#include <windows.h>
#include <windowsx.h>
#include <dwmapi.h>

static inline QByteArray qtNativeEventType() {
    static const auto result = "windows_generic_MSG";
    return result;
}

static inline bool isCompositionEnabled() {
    typedef HRESULT (WINAPI *DwmIsCompositionEnabledPtr)(BOOL *pfEnabled);
    HMODULE module = ::LoadLibraryW(L"dwmapi.dll");
    if (module) {
        BOOL composition_enabled = false;
        DwmIsCompositionEnabledPtr dwm_is_composition_enabled;
        dwm_is_composition_enabled = reinterpret_cast<DwmIsCompositionEnabledPtr>(::GetProcAddress(module, "DwmIsCompositionEnabled"));
        if (dwm_is_composition_enabled) {
            dwm_is_composition_enabled(&composition_enabled);
        }
        return composition_enabled;
    }
    return false;
}

static inline void setShadow(HWND hwnd) {
    const MARGINS shadow = {1, 0, 0, 0};
    typedef HRESULT (WINAPI *DwmExtendFrameIntoClientAreaPtr)(HWND hWnd, const MARGINS *pMarInset);
    HMODULE module = LoadLibraryW(L"dwmapi.dll");
    if (module) {
        DwmExtendFrameIntoClientAreaPtr dwm_extendframe_into_client_area_;
        dwm_extendframe_into_client_area_ = reinterpret_cast<DwmExtendFrameIntoClientAreaPtr>(GetProcAddress(module, "DwmExtendFrameIntoClientArea"));
        if (dwm_extendframe_into_client_area_) {
            dwm_extendframe_into_client_area_(hwnd, &shadow);
        }
    }
}

#endif

bool containsCursorToItem(QQuickItem *item) {
    if (!item || !item->isVisible()) {
        return false;
    }
    auto point = item->window()->mapFromGlobal(QCursor::pos());
    auto rect = QRectF(item->mapToItem(item->window()->contentItem(), QPointF(0, 0)), item->size());
    if (rect.contains(point)) {
        return true;
    }
    return false;
}

FluFrameless::FluFrameless(QQuickItem *parent) : QQuickItem{parent} {
    _fixSize = false;
    _appbar = nullptr;
    _maximizeButton = nullptr;
    _minimizedButton = nullptr;
    _closeButton = nullptr;
    _topmost = false;
    _disabled = false;
    _isWindows11OrGreater = FluTools::getInstance()->isWindows11OrGreater();
}

FluFrameless::~FluFrameless() = default;

[[maybe_unused]] void FluFrameless::onDestruction() {
    QGuiApplication::instance()->removeNativeEventFilter(this);
}

void FluFrameless::componentComplete() {
    if (_disabled) {
        return;
    }
    int w = window()->width();
    int h = window()->height();
    _current = window()->winId();
    window()->setFlags((window()->flags()) | Qt::CustomizeWindowHint | Qt::WindowMinimizeButtonHint | Qt::WindowCloseButtonHint | Qt::FramelessWindowHint);
    if (!_fixSize) {
        window()->setFlag(Qt::WindowMaximizeButtonHint);
    }
    window()->installEventFilter(this);
    QGuiApplication::instance()->installNativeEventFilter(this);
    if (_maximizeButton) {
        setHitTestVisible(_maximizeButton);
    }
    if (_minimizedButton) {
        setHitTestVisible(_minimizedButton);
    }
    if (_closeButton) {
        setHitTestVisible(_closeButton);
    }
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    DWORD style = ::GetWindowLongPtr(hwnd, GWL_STYLE);
    if (_fixSize) {
#if (QT_VERSION == QT_VERSION_CHECK(6, 5, 3) || QT_VERSION == QT_VERSION_CHECK(6, 6, 0))
        ::SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_THICKFRAME);;
#else
        ::SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_THICKFRAME | WS_CAPTION);
#endif
        for (int i = 0; i <= QGuiApplication::screens().count() - 1; ++i) {
            connect(QGuiApplication::screens().at(i), &QScreen::logicalDotsPerInchChanged, this, [=] {
                SetWindowPos(hwnd, nullptr, 0, 0, 0, 0, SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_FRAMECHANGED);
            });
        }
    } else {
#if (QT_VERSION == QT_VERSION_CHECK(6, 5, 3) || QT_VERSION == QT_VERSION_CHECK(6, 6, 0))
        ::SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_MAXIMIZEBOX | WS_THICKFRAME);
#else
        ::SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_MAXIMIZEBOX | WS_THICKFRAME | WS_CAPTION);
#endif
    }
    SetWindowPos(hwnd, nullptr, 0, 0, 0, 0, SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
    connect(window(), &QQuickWindow::screenChanged, this, [hwnd] {
        ::SetWindowPos(hwnd, nullptr, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOOWNERZORDER);
        ::RedrawWindow(hwnd, nullptr, nullptr, RDW_INVALIDATE | RDW_UPDATENOW);
    });
    if (!window()->property("_hideShadow").toBool()) {
        setShadow(hwnd);
    }
#endif
    h = qRound(h + _appbar->height());
    if (_fixSize) {
        window()->setMaximumSize(QSize(w, h));
        window()->setMinimumSize(QSize(w, h));
    }
    window()->resize(QSize(w, h));
    connect(this, &FluFrameless::topmostChanged, this, [this] {
        _setWindowTopmost(topmost());
    });
    _setWindowTopmost(topmost());
}

[[maybe_unused]] bool FluFrameless::nativeEventFilter(const QByteArray &eventType, void *message, QT_NATIVE_EVENT_RESULT_TYPE *result) {
#ifdef Q_OS_WIN
    if ((eventType != qtNativeEventType()) || !message) {
        return false;
    }
    const auto msg = static_cast<const MSG *>(message);
    auto hwnd = msg->hwnd;
    if (!hwnd) {
        return false;
    }
    const quint64 wid = reinterpret_cast<qint64>(hwnd);
    if (wid != _current) {
        return false;
    }
    const auto uMsg = msg->message;
    const auto wParam = msg->wParam;
    const auto lParam = msg->lParam;
    static int offsetXY;
    if (uMsg == WM_WINDOWPOSCHANGING) {
        auto *wp = reinterpret_cast<WINDOWPOS *>(lParam);
        if (wp != nullptr && (wp->flags & SWP_NOSIZE) == 0) {
            wp->flags |= SWP_NOCOPYBITS;
            *result = static_cast<QT_NATIVE_EVENT_RESULT_TYPE>(::DefWindowProcW(hwnd, uMsg, wParam, lParam));
            return true;
        }
        return false;
    } else if (uMsg == WM_NCCALCSIZE && wParam == TRUE) {
        const auto clientRect = &(reinterpret_cast<LPNCCALCSIZE_PARAMS>(lParam))->rgrc[0];
        const LONG originalTop = clientRect->top;
        const LONG originalLeft = clientRect->left;
        const LONG originalBottom = clientRect->bottom;
        const LONG originalRight = clientRect->right;
        const LRESULT hitTestResult = ::DefWindowProcW(hwnd, WM_NCCALCSIZE, wParam, lParam);
        if ((hitTestResult != HTERROR) && (hitTestResult != HTNOWHERE)) {
            *result = static_cast<QT_NATIVE_EVENT_RESULT_TYPE>(hitTestResult);
            return true;
        }
        if (clientRect->left - originalLeft != 0) {
            offsetXY = clientRect->left - originalLeft;
        }
#if (QT_VERSION == QT_VERSION_CHECK(6, 5, 3) || QT_VERSION == QT_VERSION_CHECK(6, 6, 0))
        clientRect->top = originalTop;
        clientRect->bottom = originalBottom;
        clientRect->left = originalLeft;
        clientRect->right = originalRight;
#else
        bool isMaximum = ::IsZoomed(hwnd);
        if (!isMaximum) {
            clientRect->top = originalTop;
            clientRect->bottom = originalBottom;
            clientRect->left = originalLeft;
            clientRect->right = originalRight;
        } else {
            clientRect->top = originalTop + offsetXY;
            clientRect->bottom = originalBottom - offsetXY;
            clientRect->left = originalLeft + offsetXY;
            clientRect->right = originalRight - offsetXY;
        }
#endif
        _setMaximizeHovered(false);
        *result = WVR_REDRAW;
        return true;
    } else if (uMsg == WM_NCHITTEST) {
        if (_isWindows11OrGreater) {
            if (_hitMaximizeButton()) {
                if (*result == HTNOWHERE) {
                    *result = HTZOOM;
                }
                _setMaximizeHovered(true);
                return true;
            }
            _setMaximizeHovered(false);
            _setMaximizePressed(false);
        }
        *result = 0;
        POINT nativeGlobalPos{GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam)};
        POINT nativeLocalPos = nativeGlobalPos;
        ::ScreenToClient(hwnd, &nativeLocalPos);
        RECT clientRect{0, 0, 0, 0};
        ::GetClientRect(hwnd, &clientRect);
        auto clientWidth = clientRect.right - clientRect.left;
        auto clientHeight = clientRect.bottom - clientRect.top;
        bool left = nativeLocalPos.x < _margins;
        bool right = nativeLocalPos.x > clientWidth - _margins;
        bool top = nativeLocalPos.y < _margins;
        bool bottom = nativeLocalPos.y > clientHeight - _margins;
        *result = 0;
        if (!_fixSize && !_isFullScreen() && !_isMaximized()) {
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
        if (_hitAppBar()) {
            *result = HTCAPTION;
            return true;
        }
        *result = HTCLIENT;
        return true;
    } else if (uMsg == WM_NCPAINT) {
        if (isCompositionEnabled()) {
            return false;
        }
        *result = FALSE;
        return true;
    } else if (uMsg == WM_NCACTIVATE) {
        if (isCompositionEnabled()) {
            return false;
        }
        *result = TRUE;
        return true;
    } else if (uMsg == WM_GETMINMAXINFO) {
        auto *minmaxInfo = reinterpret_cast<MINMAXINFO *>(lParam);
        auto pixelRatio = window()->devicePixelRatio();
        auto geometry = window()->screen()->availableGeometry();
        RECT rect;
        SystemParametersInfo(SPI_GETWORKAREA, 0, &rect, 0);
        minmaxInfo->ptMaxPosition.x = rect.left;
        minmaxInfo->ptMaxPosition.y = rect.top;
        minmaxInfo->ptMaxSize.x = qRound(geometry.width() * pixelRatio);
        minmaxInfo->ptMaxSize.y = qRound(geometry.height() * pixelRatio);
        return false;
    } else if (_isWindows11OrGreater && (uMsg == WM_NCLBUTTONDBLCLK || uMsg == WM_NCLBUTTONDOWN)) {
        if (_hitMaximizeButton()) {
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonPress, QPoint(), QPoint(), Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(_maximizeButton, &event);
            _setMaximizePressed(true);
            return true;
        }
    } else if (_isWindows11OrGreater && (uMsg == WM_NCLBUTTONUP || uMsg == WM_NCRBUTTONUP)) {
        if (_hitMaximizeButton()) {
            QMouseEvent event = QMouseEvent(QEvent::MouseButtonRelease, QPoint(), QPoint(), Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
            QGuiApplication::sendEvent(_maximizeButton, &event);
            _setMaximizePressed(false);
            return true;
        }
    } else if (uMsg == WM_NCRBUTTONDOWN) {
        if (wParam == HTCAPTION) {
            auto pos = window()->position();
            auto offset = window()->mapFromGlobal(QCursor::pos());
            _showSystemMenu(QPoint(pos.x() + offset.x(), pos.y() + offset.y()));
        }
    } else if (uMsg == WM_KEYDOWN || uMsg == WM_SYSKEYDOWN) {
        const bool altPressed = ((wParam == VK_MENU) || (::GetKeyState(VK_MENU) < 0));
        const bool spacePressed = ((wParam == VK_SPACE) || (::GetKeyState(VK_SPACE) < 0));
        if (altPressed && spacePressed) {
            auto pos = window()->position();
            _showSystemMenu(QPoint(pos.x(), qRound(pos.y() + _appbar->height())));
        }
    } else if (uMsg == WM_SYSCOMMAND) {
        if (wParam == SC_MINIMIZE) {
            if (window()->transientParent()) {
                auto _hwnd = reinterpret_cast<HWND>(window()->transientParent()->winId());
                ::ShowWindow(_hwnd, 2);
            } else {
                auto _hwnd = reinterpret_cast<HWND>(window()->winId());
                ::ShowWindow(_hwnd, 2);
            }
            return true;
        }
        return false;
    }
    return false;
#else
    return false;
#endif
}

bool FluFrameless::_isMaximized() {
    return window()->visibility() == QWindow::Maximized;
}

bool FluFrameless::_isFullScreen() {
    return window()->visibility() == QWindow::FullScreen;
}

void FluFrameless::_showSystemMenu(QPoint point) {
#ifdef Q_OS_WIN
    QScreen *screen = window()->screen();
    if (!screen) {
        screen = QGuiApplication::primaryScreen();
    }
    if (!screen) {
        return;
    }
    const QPoint origin = screen->geometry().topLeft();
    auto nativePos = QPointF(QPointF(point - origin) * window()->devicePixelRatio()).toPoint() + origin;
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    DWORD style = ::GetWindowLongPtr(hwnd, GWL_STYLE);
    ::SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_SYSMENU);
    auto hMenu = ::GetSystemMenu(hwnd, FALSE);
    if (_isMaximized() || _isFullScreen()) {
        ::EnableMenuItem(hMenu, SC_MOVE, MFS_DISABLED);
        ::EnableMenuItem(hMenu, SC_RESTORE, MFS_ENABLED);
    } else {
        ::EnableMenuItem(hMenu, SC_MOVE, MFS_ENABLED);
        ::EnableMenuItem(hMenu, SC_RESTORE, MFS_DISABLED);
    }
    if (!_fixSize && !_isMaximized() && !_isFullScreen()) {
        ::EnableMenuItem(hMenu, SC_SIZE, MFS_ENABLED);
        ::EnableMenuItem(hMenu, SC_MAXIMIZE, MFS_ENABLED);
    } else {
        ::EnableMenuItem(hMenu, SC_SIZE, MFS_DISABLED);
        ::EnableMenuItem(hMenu, SC_MAXIMIZE, MFS_DISABLED);
    }
    const int result = ::TrackPopupMenu(hMenu, (TPM_RETURNCMD | (QGuiApplication::isRightToLeft() ? TPM_RIGHTALIGN : TPM_LEFTALIGN)), nativePos.x(),
                                        nativePos.y(), 0, hwnd, nullptr);
    if (result != FALSE) {
        ::PostMessageW(hwnd, WM_SYSCOMMAND, result, 0);
    }
    ::SetWindowLongPtr(hwnd, GWL_STYLE, style & ~WS_SYSMENU);
#endif
}

bool FluFrameless::_hitAppBar() {
    for (int i = 0; i <= _hitTestList.size() - 1; ++i) {
        auto item = _hitTestList.at(i);
        if (containsCursorToItem(item)) {
            return false;
        }
    }
    if (containsCursorToItem(_appbar)) {
        return true;
    }
    return false;
}

bool FluFrameless::_hitMaximizeButton() {
    if (containsCursorToItem(_maximizeButton)) {
        return true;
    }
    return false;
}

void FluFrameless::_setMaximizePressed(bool val) {
    _maximizeButton->setProperty("down", val);
}

void FluFrameless::_setMaximizeHovered(bool val) {
    _maximizeButton->setProperty("hover", val);
}

void FluFrameless::_updateCursor(int edges) {
    switch (edges) {
        case 0:
            window()->setCursor(Qt::ArrowCursor);
            break;
        case Qt::LeftEdge:
        case Qt::RightEdge:
            window()->setCursor(Qt::SizeHorCursor);
            break;
        case Qt::TopEdge:
        case Qt::BottomEdge:
            window()->setCursor(Qt::SizeVerCursor);
            break;
        case Qt::LeftEdge | Qt::TopEdge:
        case Qt::RightEdge | Qt::BottomEdge:
            window()->setCursor(Qt::SizeFDiagCursor);
            break;
        case Qt::RightEdge | Qt::TopEdge:
        case Qt::LeftEdge | Qt::BottomEdge:
            window()->setCursor(Qt::SizeBDiagCursor);
            break;
        default:
            break;
    }
}

[[maybe_unused]] void FluFrameless::showFullScreen() {
    window()->showFullScreen();
}

void FluFrameless::showMaximized() {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    ::ShowWindow(hwnd, 3);
#else
    window()->setVisibility(QQuickWindow::Maximized);
#endif
}

[[maybe_unused]] void FluFrameless::showMinimized() {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    ::ShowWindow(hwnd, 2);
#else
    window()->setVisibility(QQuickWindow::Minimized);
#endif
}

void FluFrameless::showNormal() {
    window()->setVisibility(QQuickWindow::Windowed);
}

void FluFrameless::setHitTestVisible(QQuickItem *val) {
    if (!_hitTestList.contains(val)) {
        _hitTestList.append(val);
    }
}

void FluFrameless::_setWindowTopmost(bool topmost) {
#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(window()->winId());
    if (topmost) {
        ::SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    } else {
        ::SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    }
#else
    window()->setFlag(Qt::WindowStaysOnTopHint,topmost);
#endif
}

bool FluFrameless::eventFilter(QObject *obj, QEvent *ev) {
#ifndef Q_OS_WIN
    switch (ev->type()) {
    case QEvent::MouseButtonPress:
        if(_edges!=0){
            QMouseEvent *event = static_cast<QMouseEvent*>(ev);
            if(event->button() == Qt::LeftButton){
                _updateCursor(_edges);
                window()->startSystemResize(Qt::Edges(_edges));
            }
        }else{
            if(_hitAppBar()){
                qint64 clickTimer = QDateTime::currentMSecsSinceEpoch();
                qint64 offset =  clickTimer - this->_clickTimer;
                this->_clickTimer = clickTimer;
                if(offset<300){
                    if(_isMaximized()){
                        showNormal();
                    }else{
                        showMaximized();
                    }
                }else{
                    window()->startSystemMove();
                }
            }
        }
        break;
    case QEvent::MouseButtonRelease:
        _edges = 0;
        break;
    case QEvent::MouseMove: {
        if(_isMaximized() || _isFullScreen()){
            break;
        }
        if(_fixSize){
            break;
        }
        QMouseEvent *event = static_cast<QMouseEvent*>(ev);
        QPoint p =
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
            event->pos();
#else
            event->position().toPoint();
#endif
        if(p.x() >= _margins && p.x() <= (window()->width() - _margins) && p.y() >= _margins && p.y() <= (window()->height() - _margins)){
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
        if ( p.x() > (window()->width() - _margins) ) {
            _edges |= Qt::RightEdge;
        }
        if ( p.y() < _margins ) {
            _edges |= Qt::TopEdge;
        }
        if ( p.y() > (window()->height() - _margins) ) {
            _edges |= Qt::BottomEdge;
        }
        _updateCursor(_edges);
        break;
    }
    default:
        break;
    }
#endif
    return QObject::eventFilter(obj, ev);
}
