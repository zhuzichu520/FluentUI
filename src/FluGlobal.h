#ifndef FLUGLOBAL_H
#define FLUGLOBAL_H

#include <QtGlobal>
#include <QQmlApplicationEngine>

namespace  FluentUI {
    Q_DECL_EXPORT void preInit();
    Q_DECL_EXPORT void postInit();
    Q_DECL_EXPORT void initEngine(QQmlApplicationEngine* engine);
}

#endif // FLUGLOBAL_H
