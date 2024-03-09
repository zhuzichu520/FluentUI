#include "TranslateHelper.h"

#include <QGuiApplication>
#include <QQmlEngine>

#include "SettingsHelper.h"

TranslateHelper::TranslateHelper(QObject *parent) : QObject(parent)
{
    _languages<<"en";
    _languages<<"zh";
    _current = SettingsHelper::getInstance()->getLanguage();
}

TranslateHelper::~TranslateHelper() = default;

void TranslateHelper::init(QQmlEngine* engine){
    _engine = engine;
    _translator = new QTranslator(this);
    qApp->installTranslator(_translator);
    QString translatorPath = QGuiApplication::applicationDirPath()+"/i18n";
#ifdef Q_OS_MACX
    translatorPath.append("/../Resources/");
#endif
    _translator->load(QString::fromStdString("%1/example_%2.qm").arg(translatorPath,_current));
    _engine->retranslate();
}
