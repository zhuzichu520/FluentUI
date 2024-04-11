#include "FileWatcher.h"

FileWatcher::FileWatcher(QObject *parent) : QObject{parent} {
    connect(&_watcher, &QFileSystemWatcher::fileChanged, this, [=](const QString &path) {
        Q_EMIT fileChanged();
        clean();
        _watcher.addPath(_path);
    });
    connect(this, &FileWatcher::pathChanged, this, [=]() {
        clean();
        _watcher.addPath(_path.replace("file:///", ""));
    });
    if (!_path.isEmpty()) {
        _watcher.addPath(_path);
    }
}

void FileWatcher::clean() {
    for (int i = 0; i <= _watcher.files().size() - 1; ++i) {
        auto item = _watcher.files().at(i);
        _watcher.removePath(item);
    }
}
