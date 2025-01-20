#pragma once

/**
 * @brief The Singleton class
 */
template <typename T>
class ExampleSingleton {
public:
    static T *getInstance();
};

template <typename T>
T *ExampleSingleton<T>::getInstance() {
    static T *instance = new T();
    return instance;
}

#define EXAMPLESINGLETON(Class)                                                                           \
private:                                                                                           \
    friend class ExampleSingleton<Class>;                                                                 \
                                                                                                   \
public:                                                                                            \
    static Class *getInstance() {                                                                  \
        return ExampleSingleton<Class>::getInstance();                                                    \
    }
