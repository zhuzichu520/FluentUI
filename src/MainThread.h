#ifndef MAINTHREAD_H
#define MAINTHREAD_H

#include <QObject>
#include <QPointer>
#include <QDebug>

class MainThread : public QObject
{
    Q_OBJECT
public:
    static void post(std::function<void()> func);
    ~MainThread();
private:
    static std::shared_ptr<MainThread> createShared(QObject* bindObject = nullptr);
private slots:
    void mainThreadSlot(std::function<void()> func);
private:
    MainThread(QObject* bindObject = nullptr);
    QPointer<QObject> _bindObject;
    bool _ignoreNullObject{ false };
};
#endif // MAINTHREAD_H
