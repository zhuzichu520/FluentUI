#ifndef TRANSLATEHELPER_H
#define TRANSLATEHELPER_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QTranslator>
#include "src/singleton.h"
#include "src/stdafx.h"

class TranslateHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,current)
    Q_PROPERTY_READONLY_AUTO(QStringList,languages)
private:
    explicit TranslateHelper(QObject* parent = nullptr);
public:
    SINGLETON(TranslateHelper)
    ~TranslateHelper() override;
    void init(QQmlEngine* engine);
private:
    QQmlEngine* _engine = nullptr;
    QTranslator* _translator = nullptr;
};

#endif // TRANSLATEHELPER_H
