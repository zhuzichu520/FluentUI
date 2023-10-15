#ifndef WINDOWLIFECYCLE_H
#define WINDOWLIFECYCLE_H

#include <QObject>
#include <QQuickWindow>
#include <QtQml/qqml.h>
#include <QQuickItem>
#include <QWindow>
#include <QJsonObject>

/**
 * @brief The WindowLifecycle class
 */
class WindowLifecycle : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(WindowLifecycle)
public:
    explicit WindowLifecycle(QObject *parent = nullptr);
    Q_INVOKABLE void onCompleted(QQuickWindow* window);
    Q_INVOKABLE void onDestruction();
    Q_INVOKABLE void onVisible(bool visible);
    Q_INVOKABLE void onDestoryOnClose();
    Q_INVOKABLE QVariant createRegister(QQuickWindow* window,const QString& path);
    void vsyncEnable(bool enable);
private:
    QQuickWindow* _window;
};

#endif // WINDOWLIFECYCLE_H
