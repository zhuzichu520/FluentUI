#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QQmlEngine>

class FluentUI
{

public:
    static void create(QQmlEngine* engine);
    static QString version();
};

#endif // FLUENTUI_H
