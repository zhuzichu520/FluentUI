#ifndef WINDOWHELPER_H
#define WINDOWHELPER_H

#include <QObject>
#include <QQuickWindow>
#include <QQuickItem>

class WindowHelper : public QObject, public QQmlParserStatus
{
    Q_OBJECT

public:
    explicit WindowHelper(QObject *parent = nullptr);
    void classBegin() override;
    void componentComplete() override;

    Q_INVOKABLE void setTitle(const QString& text);
private:

  QQuickWindow* window;

};

#endif // WINDOWHELPER_H
