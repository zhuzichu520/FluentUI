#ifndef SINGLETON_H
#define SINGLETON_H

#include <QMutex>
#include <QScopedPointer>
#include <memory>
#include <mutex>

template <typename T>
class Singleton {
public:
    static T* getInstance();

    Singleton(const Singleton& other) = delete;
    Singleton<T>& operator=(const Singleton& other) = delete;

private:
    static std::mutex mutex;
    static T* instance;
};

template <typename T>
std::mutex Singleton<T>::mutex;
template <typename T>
T* Singleton<T>::instance;
template <typename T>
T* Singleton<T>::getInstance() {
    if (instance == nullptr) {
        std::lock_guard<std::mutex> locker(mutex);
        if (instance == nullptr) {
            instance = new T();
        }
    }
    return instance;
}

#define SINGLETON(Class)                              \
private:                                               \
    friend class Singleton<Class>;              \
    friend struct QScopedPointerDeleter<Class>;        \
                                                       \
    public:                                                \
    static Class* getInstance() {                      \
        return Singleton<Class>::getInstance(); \
}

#define HIDE_CONSTRUCTOR(Class)         \
private:                                \
    Class() = default;                  \
    Class(const Class& other) = delete; \
    Class& operator=(const Class& other) = delete;

#endif // SINGLETON_H
