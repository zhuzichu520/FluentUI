#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QObject>
#include <QQmlEngine>

class FluentUI : public QObject
{
    Q_OBJECT
public:
    static FluentUI *getInstance();
    Q_DECL_EXPORT void registerTypes(QQmlEngine *engine);
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
private:
    static FluentUI* m_instance;
};

#endif // FLUENTUI_H
