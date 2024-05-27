#pragma once

#include <QObject>
#include <QtQml/qqml.h>
#include <QFont>
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The FluTextStyle class
 */
class FluTextStyle : public QObject {
    Q_OBJECT
public:
    Q_PROPERTY_AUTO(QString, family)
    Q_PROPERTY_AUTO(QFont, Caption);
    Q_PROPERTY_AUTO(QFont, Body);
    Q_PROPERTY_AUTO(QFont, BodyStrong);
    Q_PROPERTY_AUTO(QFont, Subtitle);
    Q_PROPERTY_AUTO(QFont, Title);
    Q_PROPERTY_AUTO(QFont, TitleLarge);
    Q_PROPERTY_AUTO(QFont, Display);
    QML_NAMED_ELEMENT(FluTextStyle)
    QML_SINGLETON

#if (QT_VERSION < QT_VERSION_CHECK(6, 2, 0))
public:
#else
private:
#endif
    explicit FluTextStyle(QObject *parent = nullptr);
    SINGLETON(FluTextStyle)
#if (QT_VERSION >= QT_VERSION_CHECK(6, 2, 0))
public:
    static FluTextStyle *create(QQmlEngine *, QJSEngine *) { return getInstance(); }
#endif
};
