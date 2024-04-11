#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQuickItem>
#include <QTimer>
#include <QUuid>
#include <QFontDatabase>
#include <QClipboard>
#include <QTranslator>

FluApp::FluApp(QObject *parent) : QObject{parent} {
    _useSystemAppBar = false;
}

FluApp::~FluApp() = default;

void FluApp::init(QObject *target, QLocale locale) {
    _locale = locale;
    _engine = qmlEngine(target);
    _translator = new QTranslator(this);
    qApp->installTranslator(_translator);
    const QStringList uiLanguages = _locale.uiLanguages();
    for (const QString &name: uiLanguages) {
        const QString baseName = "fluentui_" + QLocale(name).name();
        if (_translator->load(":/qt/qml/FluentUI/i18n/" + baseName)) {
            _engine->retranslate();
            break;
        }
    }
}
