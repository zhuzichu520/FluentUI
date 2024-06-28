#pragma once

#include <QtCore/qstring.h>

namespace Log {
    QString prettyProductInfoWrapper();
    void setup(char *argv[], const QString &app, int level = 4);
}
