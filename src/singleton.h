#ifndef SINGLETON_H
#define SINGLETON_H

#include <QMutex>

template <typename T>
class Singleton {
public:
    static T* getInstance();

private:
    Q_DISABLE_COPY_MOVE(Singleton)
};

template <typename T>
T* Singleton<T>::getInstance() {
    static QMutex mutex;
    QMutexLocker locker(&mutex);
    static T* instance = nullptr;
    if (instance == nullptr) {
        instance = new T();
    }
    return instance;
}

#define SINGLETON(Class)                        \
private:                                        \
    friend class Singleton<Class>;              \
    public:                                     \
    static Class* getInstance() {               \
        return Singleton<Class>::getInstance(); \
}

#define HIDE_CONSTRUCTOR(Class)         \
private:                                \
    Class() = default;                  \
    Class(const Class& other) = delete; \
    Q_DISABLE_COPY_MOVE(Class);

#endif // SINGLETON_H
