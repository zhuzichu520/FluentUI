#include "FramelessView.h"
#include <QGuiApplication>
#include <QQuickItem>
#include <QScreen>
#include <QWindow>

class FramelessViewPrivate
{
public:
    bool m_isMax = false;
    bool m_isFull = false;
    bool m_deleteLater = false;
    QQuickItem *m_titleItem = nullptr;
};
FramelessView::FramelessView(QWindow *parent) : Super(parent), d(new FramelessViewPrivate)
{
    setFlags(Qt::CustomizeWindowHint | Qt::Window | Qt::FramelessWindowHint | Qt::WindowMinMaxButtonsHint | Qt::WindowTitleHint | Qt::WindowSystemMenuHint);
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
    Super::showEvent(e);
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
    return Super::nativeEvent(eventType, message, result);
}

void FramelessView::resizeEvent(QResizeEvent *e)
{
    Super::resizeEvent(e);
}
