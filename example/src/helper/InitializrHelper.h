#ifndef INITIALIZRHELPER_H
#define INITIALIZRHELPER_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QDir>
#include "src/singleton.h"

class InitializrHelper : public QObject
{
    Q_OBJECT
private:
    explicit InitializrHelper(QObject* parent = nullptr);
    bool copyDir(const QDir& fromDir, const QDir& toDir, bool coverIfFileExists = true);
    void copyFile(const QString& source,const QString& dest);
    template <typename...Args>
    void templateToFile(const QString& source,const QString& dest,Args &&...args);
public:
    SINGLETON(InitializrHelper)
    ~InitializrHelper() override;
    Q_INVOKABLE void generate(const QString& name,const QString& path);
    Q_SIGNAL void error(const QString& message);
    Q_SIGNAL void success(const QString& path);
};

#endif // INITIALIZRHELPER_H
