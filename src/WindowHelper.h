#ifndef WINDOWHELPER_H
#define WINDOWHELPER_H

#include <QObject>
#include <QQuickWindow>
#include <QQuickItem>
#include <QWindow>
#include <QJsonObject>

class WindowHelper : public QObject
{
    Q_OBJECT

public:
    explicit WindowHelper(QObject *parent = nullptr);

    Q_INVOKABLE void initWindow(QQuickWindow* window);
    Q_INVOKABLE void destoryWindow();
    Q_INVOKABLE QVariant createRegister(QQuickWindow* window,const QString& path);

    Q_INVOKABLE void firstUpdate();

private:
    QQuickWindow* window;
    bool isFisrt=true;
};

#endif // WINDOWHELPER_H
