#include "FramelessView.h"
#include <QGuiApplication>
#include <QQuickItem>
#include <QScreen>
#include <QWindow>
#include <FluTheme.h>
#include <QTimer>

#include <dwmapi.h>
#include <windowsx.h>
#pragma comment(lib, "Dwmapi.lib")
#pragma comment(lib, "User32.lib")

static bool isMaxWin(QWindow* win)
{
    return win->windowState() == Qt::WindowMaximized;
}
static bool isFullWin(QQuickView* win)
{
    return win->windowState() == Qt::WindowFullScreen;
}

static long hitTest(RECT winrect, long x, long y, int borderWidth)
{
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

class FramelessViewPrivate
{
public:
    bool m_isMax = false;
    bool m_isFull = false;
    bool m_deleteLater = false;
    bool m_isFirst = true;
    QQuickItem *m_titleItem = nullptr;
};

FramelessView::FramelessView(QWindow *parent) : Super(parent), d(new FramelessViewPrivate)
{
    setFlags( Qt::Window | Qt::FramelessWindowHint | Qt::WindowTitleHint | Qt::WindowSystemMenuHint);
    setResizeMode(SizeRootObjectToView);
    setIsMax(windowState() == Qt::WindowMaximized);
    setIsFull(windowState() == Qt::WindowFullScreen);
    connect(this, &QWindow::windowStateChanged, this, [&](Qt::WindowState state) {
        (void)state;
        setIsMax(windowState() == Qt::WindowMaximized);
        setIsFull(windowState() == Qt::WindowFullScreen);
    });
}

FramelessView::~FramelessView()
{
    delete d;
}

void FramelessView::showEvent(QShowEvent *e)
{
    static const MARGINS shadow_state[2] { { 0, 0, 0, 0 }, { 1, 1, 1, 1 } };
    ::DwmExtendFrameIntoClientArea((HWND)(winId()), &shadow_state[true]);
    Super::showEvent(e);
    if(d->m_isFirst){
        QTimer::singleShot(150,this,[=](){ setFlag(Qt::FramelessWindowHint,false); });
    }
    setFlag(Qt::FramelessWindowHint,false);
}

QRect FramelessView::calcCenterGeo(const QRect &screenGeo, const QSize &normalSize)
{
    int w = normalSize.width();
    int h = normalSize.height();
    int x = screenGeo.x() + (screenGeo.width() - w) / 2;
    int y = screenGeo.y() + (screenGeo.height() - h) / 2;
    if (screenGeo.width() < w) {
        x = screenGeo.x();
        w = screenGeo.width();
    }
    if (screenGeo.height() < h) {
        y = screenGeo.y();
        h = screenGeo.height();
    }
    return { x, y, w, h };
}

void FramelessView::moveToScreenCenter()
{
    auto geo = calcCenterGeo(screen()->availableGeometry(), size());
    if (minimumWidth() > geo.width() || minimumHeight() > geo.height()) {
        setMinimumSize(geo.size());
    }
    setGeometry(geo);
    update();
}

void FramelessView::closeDeleteLater(){
    d->m_deleteLater = true;
}

bool FramelessView::isMax() const
{
    return d->m_isMax;
}

bool FramelessView::isFull() const
{
    return d->m_isFull;
}

QQuickItem *FramelessView::titleItem() const
{
    return d->m_titleItem;
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
    if(d->m_isFull == isFull)
        return;

    d->m_isFull = isFull;
    emit isFullChanged(d->m_isFull);
}

void FramelessView::setTitleItem(QQuickItem *item)
{
    d->m_titleItem = item;
}
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
bool FramelessView::nativeEvent(const QByteArray &eventType, void *message, qintptr *result)
#else
bool FramelessView::nativeEvent(const QByteArray &eventType, void *message, long *result)
#endif
{
    MSG* msg = static_cast<MSG*>(message);
    if (!msg || !msg->hwnd)
    {
        return false;
    }
    if (msg->message == WM_NCHITTEST)
    {
        RECT winrect;
        GetWindowRect(HWND(winId()), &winrect);
        long x = GET_X_LPARAM(msg->lParam);
        long y = GET_Y_LPARAM(msg->lParam);
        *result = 0;
        if (!isMaxWin(this) && !isFullWin(this))
        {
            *result = hitTest(winrect, x, y, 4);
            if (0 != *result)
            {
                return true;
            }
        }
    }else if (msg->message == WM_NCCALCSIZE)
    {
        const auto mode = static_cast<BOOL>(msg->wParam);
        const auto clientRect = mode ? &(reinterpret_cast<LPNCCALCSIZE_PARAMS>(msg->lParam)->rgrc[0]) : reinterpret_cast<LPRECT>(msg->lParam);
        if (mode == TRUE)
        {
            *result = WVR_REDRAW;
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
    }
    return Super::nativeEvent(eventType, message, result);
}

void FramelessView::resizeEvent(QResizeEvent *e)
{
    Super::resizeEvent(e);
}

bool FramelessView::event(QEvent *ev)
{
    if (ev->type() == QEvent::Close) {
        if(d->m_deleteLater){
            deleteLater();
            ev->setAccepted(false);
        }
    }
    return QQuickWindow::event(ev);
}

