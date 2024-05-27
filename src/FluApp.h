#pragma once

#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include <QTranslator>
#include <QQuickWindow>
#include <QJsonArray>
#include "stdafx.h"
#include "singleton.h"

/**
 * @brief The FluApp class
 */
class FluApp : public QObject {
    Q_OBJECT

    Q_PROPERTY_AUTO(bool, useSystemAppBar)
    Q_PROPERTY_AUTO(QString, windowIcon)
    Q_PROPERTY_AUTO(QLocale, locale)
    Q_PROPERTY_AUTO_P(QObject*,launcher)
    QML_NAMED_ELEMENT(FluApp)
    QML_SINGLETON

#if (QT_VERSION < QT_VERSION_CHECK(6, 2, 0))
public:
#else
private:
#endif
    explicit FluApp(QObject *parent = nullptr);

    ~FluApp() override;

public:
    SINGLETON(FluApp)
#if (QT_VERSION >= QT_VERSION_CHECK(6, 2, 0))
    static FluApp *create(QQmlEngine *, QJSEngine *) { return getInstance(); }
#endif
    Q_INVOKABLE void init(QObject *launcher, QLocale locale = QLocale::system());

    [[maybe_unused]] Q_INVOKABLE static QJsonArray iconData(const QString &keyword = "");

private:
    QQmlEngine *_engine{};
    QTranslator *_translator = nullptr;
};
