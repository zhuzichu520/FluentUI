#pragma once

/**
 * @brief The Singleton class
 */
template<typename T>
class Singleton {
public:
    static T *getInstance();
};

template<typename T>
T *Singleton<T>::getInstance() {
    static T *instance = new T();
    return instance;
}

#define SINGLETON(Class)                        \
private:                                        \
    friend class Singleton<Class>;              \
    public:                                     \
    static Class* getInstance() {               \
        return Singleton<Class>::getInstance(); \
}
