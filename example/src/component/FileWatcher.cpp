#include "FileWatcher.h"

FileWatcher::FileWatcher(QObject *parent)
    : QObject{parent}
{
    connect(&_watcher, &QFileSystemWatcher::fileChanged, this, [=](const QString &path){
        Q_EMIT fileChanged();
        clean();
        _watcher.addPath(_path);
    });
    connect(this,&FileWatcher::pathChanged,this,[=](){
        clean();
        _watcher.addPath(_path.replace("file:///",""));
    });
    if(!_path.isEmpty()){
        _watcher.addPath(_path);
    }
}

void FileWatcher::clean(){
    foreach (const QString &item,  _watcher.files()) {
        _watcher.removePath(item);
    }
}
