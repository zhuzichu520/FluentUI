#pragma once

#include <QMouseEvent>
#include <QQuickView>
#include <QRegion>

class FramelessViewPrivate;
class FramelessView : public QQuickView
{
    Q_OBJECT
    using Super = QQuickView;
    Q_PROPERTY(bool isMax READ isMax NOTIFY isMaxChanged)
    Q_PROPERTY(bool isFull READ isFull NOTIFY isFullChanged)
public:
    explicit FramelessView(QWindow *parent = nullptr);
    ~FramelessView();
    void moveToScreenCenter();
    void closeDeleteLater();
    bool isMax() const;
    bool isFull() const;
    QQuickItem *titleItem() const;

    static QMap<WId,FramelessView*> *windowCache;
    static QRect calcCenterGeo(const QRect &screenGeo, const QSize &normalSize);
public slots:
    void setIsMax(bool isMax);
    void setIsFull(bool isFull);
    void setTitleItem(QQuickItem* item);

signals:
    void isMaxChanged(bool isMax);
    void isFullChanged(bool isFull);
    void mousePressed(int xPos, int yPos, int button);

protected:
    void showEvent(QShowEvent *e) override;
    void resizeEvent(QResizeEvent *e) override;
    bool event(QEvent *ev) override;
#    if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    bool nativeEvent(const QByteArray &eventType, void *message, qintptr *result) override;
#    else
    bool nativeEvent(const QByteArray &eventType, void *message, long *result) override;
#    endif
    void mousePressEvent(QMouseEvent* event) override
    {
#    if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        emit mousePressed(event->position().x(), event->position().y(), event->button());
#else
        emit mousePressed(event->x(), event->y(), event->button());
#endif
        Super::mousePressEvent(event);
    }

private:
    FramelessViewPrivate *d;
};
