#ifndef FLUWINDOWLIFECYCLE_H
#define FLUWINDOWLIFECYCLE_H

#include <QObject>
#include <QQuickWindow>
#include <QtQml/qqml.h>
#include <QQuickItem>
#include <QWindow>
#include <QJsonObject>

/**
 * @brief The FluWindowLifecycle class
 */
class FluWindowLifecycle : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(FluWindowLifecycle)
public:
    explicit FluWindowLifecycle(QObject *parent = nullptr);
    Q_INVOKABLE void onCompleted(QQuickWindow* window);
    Q_INVOKABLE void onDestruction();
    Q_INVOKABLE void onVisible(bool visible);
    Q_INVOKABLE void onDestoryOnClose();
    Q_INVOKABLE QVariant createRegister(QQuickWindow* window,const QString& path);
private:
    QQuickWindow* _window = nullptr;
};

#endif // FLUWINDOWLIFECYCLE_H
