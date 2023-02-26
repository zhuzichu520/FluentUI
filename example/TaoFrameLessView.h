#pragma once

#include <QMouseEvent>
#include <QQuickView>
#include <QRegion>

//无边框窗口，主要用来实现自定义标题栏。
//Windows平台支持拖动和改变大小，支持Aero效果
//非Windows平台，去掉边框，不做其它处理。由Qml模拟resize和拖动。
class TaoFrameLessViewPrivate;
class TaoFrameLessView : public QQuickView
{
    Q_OBJECT
    using Super = QQuickView;
    Q_PROPERTY(bool isMax READ isMax NOTIFY isMaxChanged)
    Q_PROPERTY(bool isFull READ isFull NOTIFY isFullChanged)
public:
    explicit TaoFrameLessView(QWindow *parent = nullptr);
    ~TaoFrameLessView();
    void moveToScreenCenter();
    bool isMax() const;
    bool isFull() const;
    QQuickItem *titleItem() const;

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
    TaoFrameLessViewPrivate *d;
};
