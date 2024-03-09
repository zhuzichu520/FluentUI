#include "SettingsHelper.h"

#include <QDataStream>
#include <QStandardPaths>

SettingsHelper::SettingsHelper(QObject *parent) : QObject(parent)
{

}

SettingsHelper::~SettingsHelper() = default;

void SettingsHelper::save(const QString& key,QVariant val)
{
    m_settings->setValue(key, val);
}

QVariant SettingsHelper::get(const QString& key,QVariant def){
    QVariant data = m_settings->value(key);
    if (!data.isNull() && data.isValid()) {
        return data;
    }
    return def;
}

void SettingsHelper::init(char *argv[]){
    QString applicationPath = QString::fromStdString(argv[0]);
    const QFileInfo fileInfo(applicationPath);
    const QString iniFileName = fileInfo.completeBaseName() + ".ini";
    const QString iniFilePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/" + iniFileName;
    m_settings.reset(new QSettings(iniFilePath, QSettings::IniFormat));
}
