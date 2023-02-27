#include "FramelessView.h"

#include <QGuiApplication>
#include <QQuickItem>
#include <QScreen>
#include <QWindow>

#include <VersionHelpers.h>
#include <WinUser.h>
#include <dwmapi.h>
#include <objidl.h> // Fixes error C2504: 'IUnknown' : base class undefined
#include <windows.h>
#include <windowsx.h>
#include <wtypes.h>
#pragma comment(lib, "Dwmapi.lib") // Adds missing library, fixes error LNK2019: unresolved
#pragma comment(lib, "User32.lib")
#pragma comment(lib, "Gdi32.lib")
// we cannot just use WS_POPUP style
// WS_THICKFRAME: without this the window cannot be resized and so aero snap, de-maximizing and minimizing won't work
// WS_SYSMENU: enables the context menu with the move, close, maximize, minize... commands (shift + right-click on the task bar item)
// WS_CAPTION: enables aero minimize animation/transition
// WS_MAXIMIZEBOX, WS_MINIMIZEBOX: enable minimize/maximize

QMap<WId,FramelessView*>* FramelessView::windowCache = new QMap<WId,FramelessView*>;


enum class Style : DWORD
{
    windowed = WS_OVERLAPPEDWINDOW | WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MAXIMIZEBOX | WS_MINIMIZEBOX,
    aero_borderless = WS_POPUP | WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MAXIMIZEBOX | WS_MINIMIZEBOX,
    basic_borderless = WS_POPUP | WS_THICKFRAME | WS_SYSMENU | WS_MAXIMIZEBOX | WS_MINIMIZEBOX
};
static bool isCompositionEnabled()
{
    BOOL composition_enabled = FALSE;
    bool success = ::DwmIsCompositionEnabled(&composition_enabled) == S_OK;
    return composition_enabled && success;
}
static Style selectBorderLessStyle()
{
    return isCompositionEnabled() ? Style::aero_borderless : Style::basic_borderless;
}
static void setShadow(HWND handle, bool enabled)
{
    if (isCompositionEnabled())
    {
        static const MARGINS shadow_state[2] { { 0, 0, 0, 0 }, { 1, 1, 1, 1 } };
        ::DwmExtendFrameIntoClientArea(handle, &shadow_state[enabled]);
    }
}
static long hitTest(RECT winrect, long x, long y, int borderWidth)
{
    // 鼠标区域位于窗体边框，进行缩放
    if ((x >= winrect.left) && (x < winrect.left + borderWidth) && (y >= winrect.top) && (y < winrect.top + borderWidth))
    {
        return HTTOPLEFT;
    }
    else if (x < winrect.right && x >= winrect.right - borderWidth && y >= winrect.top && y < winrect.top + borderWidth)
    {
        return HTTOPRIGHT;
    }
    else if (x >= winrect.left && x < winrect.left + borderWidth && y < winrect.bottom && y >= winrect.bottom - borderWidth)
    {
        return HTBOTTOMLEFT;
    }
    else if (x < winrect.right && x >= winrect.right - borderWidth && y < winrect.bottom && y >= winrect.bottom - borderWidth)
    {
        return HTBOTTOMRIGHT;
    }
    else if (x >= winrect.left && x < winrect.left + borderWidth)
    {
        return HTLEFT;
    }
    else if (x < winrect.right && x >= winrect.right - borderWidth)
    {
        return HTRIGHT;
    }
    else if (y >= winrect.top && y < winrect.top + borderWidth)
    {
        return HTTOP;
    }
    else if (y < winrect.bottom && y >= winrect.bottom - borderWidth)
    {
        return HTBOTTOM;
    }
    else
    {
        return 0;
    }
}

static bool isMaxWin(QWindow* win)
{
    return win->windowState() == Qt::WindowMaximized;
}
static bool isFullWin(QQuickView* win)
{
    return win->windowState() == Qt::WindowFullScreen;
}

class FramelessViewPrivate
{
public:
    bool m_firstRun = true;
    bool m_isMax = false;
    bool m_isFull = false;
    bool m_deleteLater = false;
    QQuickItem* m_titleItem = nullptr;
    HMENU mMenuHandler = NULL;
    bool borderless = true;        // is the window currently borderless
    bool borderless_resize = true; // should the window allow resizing by dragging the borders while borderless
    bool borderless_drag = true;   // should the window allow moving my dragging the client area
    bool borderless_shadow = true; // should the window display a native aero shadow while borderless
    void setBorderLess(HWND handle, bool enabled)
    {
        auto newStyle = enabled ? selectBorderLessStyle() : Style::windowed;
        auto oldStyle = static_cast<Style>(::GetWindowLongPtrW(handle, GWL_STYLE));
        if (oldStyle != newStyle)
        {
            borderless = enabled;
            ::SetWindowLongPtrW(handle, GWL_STYLE, static_cast<LONG>(newStyle));

            // when switching between borderless and windowed, restore appropriate shadow state
            setShadow(handle, borderless_shadow && (newStyle != Style::windowed));

            // redraw frame
            ::SetWindowPos(handle, nullptr, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE);
            ::ShowWindow(handle, SW_SHOW);
        }
    }
    void setBorderLessShadow(HWND handle, bool enabled)
    {
        if (borderless)
        {
            borderless_shadow = enabled;
            setShadow(handle, enabled);
        }
    }
};
FramelessView::FramelessView(QWindow* parent)
    : QQuickView(parent)
    , d(new FramelessViewPrivate)
{
    //此处不需要设置flags
    //    setFlags(Qt::CustomizeWindowHint | Qt::Window | Qt::FramelessWindowHint | Qt::WindowMinMaxButtonsHint | Qt::WindowTitleHint |
    //    Qt::WindowSystemMenuHint);
    setResizeMode(SizeRootObjectToView);

    setIsMax(windowState() == Qt::WindowMaximized);
    setIsFull(windowState() == Qt::WindowFullScreen);
    connect(this, &QWindow::windowStateChanged, this, [&](Qt::WindowState state) {
        (void)state;
        setIsMax(windowState() == Qt::WindowMaximized);
        setIsFull(windowState() == Qt::WindowFullScreen);
    });

    QObject::connect(this, &QQuickView::statusChanged, this, [&](QQuickView::Status status) {
        if (status == QQuickView::Status::Ready) {
            FramelessView::windowCache->insert(this->winId(),this);
        }
    });

}
void FramelessView::showEvent(QShowEvent* e)
{
    if (d->m_firstRun)
    {
        d->m_firstRun = false;
        //第一次show的时候，设置无边框。不在构造函数中设置。取winId会触发QWindowsWindow::create,直接创建win32窗口,引起错乱(win7 或者虚拟机启动即黑屏)。
        d->setBorderLess((HWND)(winId()), d->borderless);
        {
            // Qt 5.15.2 的bug; 问题复现及解决方法：当使用WM_NCCALCSIZE 修改非客户区大小后，移动窗口到其他屏幕时，qwindows.dll 源码 qwindowswindow.cpp:2447
            // updateFullFrameMargins() 函数 处会调用qwindowswindow.cpp:2453 的
            // calculateFullFrameMargins函数重新获取默认的非客户区大小，导致最外层窗口移动屏幕时会触发resize消息，引起40像素左右的黑边；故此处创建Menu
            // 使其调用qwindowswindow.cpp:2451 的 QWindowsContext::forceNcCalcSize() 函数计算非客户区大小

            //已知负面效果: 引入win32 MENU后，Qt程序中如果有alt开头的快捷键，会不生效，被Qt滤掉了，需要修改Qt源码
            // QWindowsKeyMapper::translateKeyEventInternal 中的
            // if (msgType == WM_SYSKEYDOWN && (nModifiers & AltAny) != 0 && GetMenu(msg.hwnd) != nullptr)
            //  return false;
            // 这两行屏蔽掉

            d->mMenuHandler = ::CreateMenu();
            ::SetMenu((HWND)winId(), d->mMenuHandler);
        }
    }
    Super::showEvent(e);
}
FramelessView::~FramelessView()
{
    if (d->mMenuHandler != NULL)
    {
        ::DestroyMenu(d->mMenuHandler);
    }
    FramelessView::windowCache->remove(this->winId());
    delete d;
}

bool FramelessView::isMax() const
{
    return d->m_isMax;
}

bool FramelessView::isFull() const
{
    return d->m_isFull;
}
QQuickItem* FramelessView::titleItem() const
{
    return d->m_titleItem;
}
void FramelessView::setTitleItem(QQuickItem* item)
{
    d->m_titleItem = item;
}
QRect FramelessView::calcCenterGeo(const QRect& screenGeo, const QSize& normalSize)
{
    int w = normalSize.width();
    int h = normalSize.height();
    int x = screenGeo.x() + (screenGeo.width() - w) / 2;
    int y = screenGeo.y() + (screenGeo.height() - h) / 2;
    if (screenGeo.width() < w)
    {
        x = screenGeo.x();
        w = screenGeo.width();
    }
    if (screenGeo.height() < h)
    {
        y = screenGeo.y();
        h = screenGeo.height();
    }

    return { x, y, w, h };
}
void FramelessView::moveToScreenCenter()
{
    auto geo = calcCenterGeo(screen()->availableGeometry(), size());
    if (minimumWidth() > geo.width() || minimumHeight() > geo.height())
    {
        setMinimumSize(geo.size());
    }
    setGeometry(geo);
    update();
}

void FramelessView::closeDeleteLater(){
    d->m_deleteLater = true;
}

void FramelessView::setIsMax(bool isMax)
{
    if (d->m_isMax == isMax)
        return;

    d->m_isMax = isMax;
    emit isMaxChanged(d->m_isMax);
}
void FramelessView::setIsFull(bool isFull)
{
    if (d->m_isFull == isFull)
        return;

    d->m_isFull = isFull;
    emit isFullChanged(d->m_isFull);
}
void FramelessView::resizeEvent(QResizeEvent* e)
{
    // SetWindowRgn(HWND(winId()), CreateRoundRectRgn(0, 0, width(), height(), 4, 4), true);
    Super::resizeEvent(e);
}

#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
bool FramelessView::nativeEvent(const QByteArray& eventType, void* message, qintptr* result)
#else
bool FramelessView::nativeEvent(const QByteArray& eventType, void* message, long* result)
#endif

{
    const long border_width = 4;
    if (!result)
    {
        //防御式编程
        //一般不会发生这种情况，win7一些极端情况，会传空指针进来。解决方案是升级驱动、切换到basic主题。
        return false;
    }

#if (QT_VERSION == QT_VERSION_CHECK(5, 11, 1))
    // Work-around a bug caused by typo which only exists in Qt 5.11.1
    const auto msg = *reinterpret_cast<MSG**>(message);
#else
    const auto msg = static_cast<LPMSG>(message);
#endif

    if (!msg || !msg->hwnd)
    {
        return false;
    }
    switch (msg->message)
    {
    case WM_CLOSE:{
        if(d->m_deleteLater){
            deleteLater();
        }
    }
    case WM_NCCALCSIZE: {
#if 1
        const auto mode = static_cast<BOOL>(msg->wParam);
        const auto clientRect = mode ? &(reinterpret_cast<LPNCCALCSIZE_PARAMS>(msg->lParam)->rgrc[0]) : reinterpret_cast<LPRECT>(msg->lParam);
        if (mode == TRUE && d->borderless)
        {
            *result = WVR_REDRAW;
            //规避 拖动border进行resize时界面闪烁
            if (!isMaxWin(this) && !isFullWin(this))
            {
                if (clientRect->top != 0)
                {
                    clientRect->top -= 0.1;
                }
            }
            else
            {
                if (clientRect->top != 0)
                {
                    clientRect->top += 0.1;
                }
            }
            return true;
        }
#else
        *result = 0;
        return true;
#endif
        break;
    }
    case WM_NCACTIVATE: {
        if (!isCompositionEnabled())
        {
            // Prevents window frame reappearing on window activation
            // in "basic" theme, where no aero shadow is present.
            *result = 1;
            return true;
        }
        break;
    }
    case WM_NCHITTEST: {
        if (d->borderless)
        {
            RECT winrect;
            GetWindowRect(HWND(winId()), &winrect);

            long x = GET_X_LPARAM(msg->lParam);
            long y = GET_Y_LPARAM(msg->lParam);

            *result = 0;
            if (!isMaxWin(this) && !isFullWin(this))
            { //非最大化、非全屏时，进行命中测试，处理边框拖拽
                *result = hitTest(winrect, x, y, border_width);
                if (0 != *result)
                {
                    return true;
                }
            }

            if (d->m_titleItem)
            {
                auto titlePos = d->m_titleItem->mapToGlobal({ 0, 0 });
                titlePos = mapFromGlobal(titlePos.toPoint());
                auto titleRect = QRect(titlePos.x(), titlePos.y(), d->m_titleItem->width(), d->m_titleItem->height());
                double dpr = qApp->devicePixelRatio();
                QPoint pos = mapFromGlobal(QPoint(x / dpr, y / dpr));
                if (titleRect.contains(pos))
                {
                    *result = HTCAPTION;
                    return true;
                }
            }
            return false;
        }
        break;
    } // end case WM_NCHITTEST
    }
    return Super::nativeEvent(eventType, message, result);
}
