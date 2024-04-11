#pragma once
#pragma clang diagnostic push
#pragma ide diagnostic ignored "NotImplementedFunctions"

#include <QtQuick/QQuickItem>
#include <QOpenGLFunctions>
#include <QQuickFramebufferObject>

class FBORenderer;

class OpenGLItem : public QQuickFramebufferObject, protected QOpenGLFunctions {
Q_OBJECT
    Q_PROPERTY(qreal t READ t WRITE setT NOTIFY tChanged)
public:
    explicit OpenGLItem(QQuickItem *parent = nullptr);

    [[nodiscard]] QQuickFramebufferObject::Renderer *createRenderer() const override;

    void timerEvent(QTimerEvent *) override;

    [[nodiscard]] qreal t() const { return m_t; }

    void setT(qreal t);

signals:

    void tChanged();

private:
    qreal m_t{};
};

#pragma clang diagnostic pop