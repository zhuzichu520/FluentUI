#pragma once

#include <QtQuick/QQuickItem>
#include <QOpenGLFunctions>
#include <QQuickFramebufferObject>

class FBORenderer;

class OpenGLItem : public QQuickFramebufferObject, protected QOpenGLFunctions {
Q_OBJECT
    Q_PROPERTY(qreal t READ t WRITE setT NOTIFY tChanged)
public:
    explicit OpenGLItem(QQuickItem *parent = nullptr);

    QQuickFramebufferObject::Renderer *createRenderer() const override;

    void timerEvent(QTimerEvent *) override;

    qreal t() const { return m_t; }

    void setT(qreal t);

signals:

    void tChanged();

private:
    qreal m_t{};
};
