#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QObject>
#include <QQmlEngine>
#include "singleton.h"

/**
 * @brief The FluentUI class
 */
class FluentUI : public QObject
{
    Q_OBJECT
public:
    SINGLETON(FluentUI)
    Q_DECL_EXPORT void registerTypes(QQmlEngine *engine);
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
private:
    const int major = 1;
    const int minor = 0;
    const char *uri = "FluentUI";
};

#endif // FLUENTUI_H
