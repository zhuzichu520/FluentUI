#include "TaoFrameLessView.h"
#include <QGuiApplication>
#include <QQuickItem>
#include <QScreen>
#include <QWindow>

class TaoFrameLessViewPrivate
{
public:
    bool m_isMax = false;
    bool m_isFull = false;
    QQuickItem *m_titleItem = nullptr;
};
TaoFrameLessView::TaoFrameLessView(QWindow *parent) : Super(parent), d(new TaoFrameLessViewPrivate)
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
TaoFrameLessView::~TaoFrameLessView()
{
    delete d;
}
void TaoFrameLessView::showEvent(QShowEvent *e)
{
    Super::showEvent(e);
}
QRect TaoFrameLessView::calcCenterGeo(const QRect &screenGeo, const QSize &normalSize)
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
void TaoFrameLessView::moveToScreenCenter()
{
    auto geo = calcCenterGeo(screen()->availableGeometry(), size());
    if (minimumWidth() > geo.width() || minimumHeight() > geo.height()) {
        setMinimumSize(geo.size());
    }
    setGeometry(geo);
    update();
}
bool TaoFrameLessView::isMax() const
{
    return d->m_isMax;
}
bool TaoFrameLessView::isFull() const
{
    return d->m_isFull;
}
QQuickItem *TaoFrameLessView::titleItem() const
{
    return d->m_titleItem;
}
void TaoFrameLessView::setIsMax(bool isMax)
{
    if (d->m_isMax == isMax)
        return;

    d->m_isMax = isMax;
    emit isMaxChanged(d->m_isMax);
}
void TaoFrameLessView::setIsFull(bool isFull)
{
    if(d->m_isFull == isFull)
        return;

    d->m_isFull = isFull;
    emit isFullChanged(d->m_isFull);
}
void TaoFrameLessView::setTitleItem(QQuickItem *item)
{
    d->m_titleItem = item;
}
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
bool TaoFrameLessView::nativeEvent(const QByteArray &eventType, void *message, qintptr *result)
#else
bool TaoFrameLessView::nativeEvent(const QByteArray &eventType, void *message, long *result)
#endif

{
    return Super::nativeEvent(eventType, message, result);
}

void TaoFrameLessView::resizeEvent(QResizeEvent *e)
{
    Super::resizeEvent(e);
}
