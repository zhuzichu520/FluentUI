#pragma once
#pragma clang diagnostic push
#pragma ide diagnostic ignored "NotImplementedFunctions"

#include <QObject>
#include <QFileSystemWatcher>
#include <QtQml/qqml.h>
#include "src/stdafx.h"

class FileWatcher : public QObject {
Q_OBJECT
Q_PROPERTY_AUTO(QString, path);
public:
    explicit FileWatcher(QObject *parent = nullptr);

    Q_SIGNAL void fileChanged();

private:
    void clean();

private:
    QFileSystemWatcher _watcher;
};

#pragma clang diagnostic pop