#ifndef SETTINGSHELPER_H
#define SETTINGSHELPER_H

#include <QtCore/qobject.h>
#include <QtQml/qqml.h>
#include <QSettings>
#include <QScopedPointer>
#include <QFileInfo>
#include <QCoreApplication>
#include <QDir>
#include "src/singleton.h"

class SettingsHelper : public QObject
{
    Q_OBJECT
private:
    explicit SettingsHelper(QObject* parent = nullptr);
public:
    SINGLETONG(SettingsHelper)
    ~SettingsHelper() override;
    void init(char *argv[]);
    Q_INVOKABLE void saveRender(const QVariant& render){save("render",render);}
    Q_INVOKABLE QVariant getRender(){return get("render");}
    Q_INVOKABLE void saveDarkMode(int darkModel){save("darkMode",darkModel);}
    Q_INVOKABLE QVariant getDarkMode(){return get("darkMode",QVariant(0));}
    Q_INVOKABLE void saveVsync(bool vsync){save("vsync",vsync);}
    Q_INVOKABLE QVariant getVsync(){return get("vsync",QVariant(true));}
private:
    void save(const QString& key,QVariant val);
    QVariant get(const QString& key,QVariant def={});
private:
    QScopedPointer<QSettings> m_settings;
};

#endif // SETTINGSHELPER_H
