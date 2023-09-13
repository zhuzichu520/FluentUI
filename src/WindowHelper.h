#ifndef WINDOWHELPER_H
#define WINDOWHELPER_H

#include <QObject>
#include <QQuickWindow>
#include <QtQml/qqml.h>
#include <QQuickItem>
#include <QWindow>
#include <QJsonObject>

/**
 * @brief The WindowHelper class
 */
class WindowHelper : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(WindowHelper)
public:
    explicit WindowHelper(QObject *parent = nullptr);
    Q_INVOKABLE void initWindow(QQuickWindow* window);
    Q_INVOKABLE QVariant createRegister(QQuickWindow* window,const QString& path);
private:
    QQuickWindow* window;
};

#endif // WINDOWHELPER_H
