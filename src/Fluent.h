#ifndef FLUENT_H
#define FLUENT_H

#include <QObject>
#include <QQmlEngine>
#include "NativeEventFilter.h"

class Fluent: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QString version() const;
    ~Fluent(){
        if (nativeEvent != Q_NULLPTR) {
               delete nativeEvent;
               nativeEvent = Q_NULLPTR;
           }
    }
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
    static Fluent *getInstance();
private:
    static Fluent* m_instance;
    NativeEventFilter *nativeEvent = Q_NULLPTR;
};

#endif // FLUENT_H
