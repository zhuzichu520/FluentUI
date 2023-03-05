#ifndef FLUENT_H
#define FLUENT_H

#include <QObject>
#include <QQmlEngine>

class Fluent: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QString version() const;
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
    static Fluent *getInstance();
private:
    static Fluent* m_instance;
};

#endif // FLUENT_H
