#pragma once

#include <QObject>
#include <QWindow>
#include <QtQml/qqml.h>
#include <QQmlContext>
#include <QJsonObject>
#include <QQmlEngine>
#include <QTranslator>
#include <QQuickWindow>
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
    QML_NAMED_ELEMENT(FluApp)
    QML_SINGLETON

private:
    explicit FluApp(QObject *parent = nullptr);

    ~FluApp() override;

public:
SINGLETON(FluApp)

    static FluApp *create(QQmlEngine *, QJSEngine *) { return getInstance(); }

    Q_INVOKABLE void init(QObject *target, QLocale locale = QLocale::system());

private:
    QQmlEngine *_engine{};
    QTranslator *_translator = nullptr;
};