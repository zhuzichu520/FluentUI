#ifndef INITALIZRHELPER_H
#define INITALIZRHELPER_H

#include <QObject>
#include <QtQml/qqml.h>
#include "src/singleton.h"

class InitalizrHelper : public QObject
{
    Q_OBJECT
private:
    explicit InitalizrHelper(QObject* parent = nullptr);
public:
    SINGLETON(InitalizrHelper)
    ~InitalizrHelper() override;
    Q_INVOKABLE void generate(const QString& name,const QString& path);
    Q_SIGNAL void error(const QString& message);
    Q_SIGNAL void success();
};

#endif // INITALIZRHELPER_H
