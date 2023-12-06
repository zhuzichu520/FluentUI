#include "SettingsHelper.h"

#include <QDataStream>
#include <QStandardPaths>

SettingsHelper::SettingsHelper(QObject *parent) : QObject(parent)
{

}

SettingsHelper::~SettingsHelper() = default;

void SettingsHelper::save(const QString& key,QVariant val)
{
    QByteArray data = {};
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream.setVersion(QDataStream::Qt_5_6);
    stream << val;
    m_settings->setValue(key, data);
}

QVariant SettingsHelper::get(const QString& key,QVariant def){
    const QByteArray data = m_settings->value(key).toByteArray();
    if (data.isEmpty()) {
        return def;
    }
    QDataStream stream(data);
    stream.setVersion(QDataStream::Qt_5_6);
    QVariant val;
    stream >> val;
    return val;
}

void SettingsHelper::init(char *argv[]){
    auto applicationPath = QString::fromStdString(argv[0]);
    const QFileInfo fileInfo(applicationPath);
    const QString iniFileName = fileInfo.completeBaseName() + ".ini";
    const QString iniFilePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/" + iniFileName;
    m_settings.reset(new QSettings(iniFilePath, QSettings::IniFormat));
}
