#include "InitalizrHelper.h"

#include <QDir>
#include <QGuiApplication>

InitalizrHelper::InitalizrHelper(QObject *parent) : QObject(parent)
{

}

InitalizrHelper::~InitalizrHelper() = default;

bool InitalizrHelper::copyDir(const QDir& fromDir, const QDir& toDir, bool coverIfFileExists){
    QDir _formDir = fromDir;
    QDir _toDir = toDir;
    if(!_toDir.exists())
    {
        if(!_toDir.mkdir(toDir.absolutePath()))
            return false;
    }
    QFileInfoList fileInfoList = _formDir.entryInfoList();
    foreach(QFileInfo fileInfo, fileInfoList)
    {
        if(fileInfo.fileName() == "." || fileInfo.fileName() == "..")
            continue;
        if(fileInfo.isDir())
        {
            if(!copyDir(fileInfo.filePath(), _toDir.filePath(fileInfo.fileName()),true))
                return false;
        }
        else
        {
            if(coverIfFileExists && _toDir.exists(fileInfo.fileName()))
            {
                _toDir.remove(fileInfo.fileName());
            }
            if(!QFile::copy(fileInfo.filePath(), _toDir.filePath(fileInfo.fileName())))
            {
                return false;
            }
        }
    }
    return true;
}

template <typename...Args>
void InitalizrHelper::templateToFile(const QString& source,const QString& dest,Args &&...args){
    QFile file(source);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        QString content = in.readAll().arg(std::forward<Args>(args)...);
        file.close();
        QDir outputDir = QFileInfo(dest).absoluteDir();
        if(!outputDir.exists()){
            outputDir.mkpath(outputDir.absolutePath());
        }
        QFile outputFile(dest);
        if (outputFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
            QTextStream out(&outputFile);
            out << content;
            outputFile.close();
        } else {
            qDebug() << "Failed to open output file.";
        }
    } else {
        qDebug() << "Failed to open resource file.";
    }
}

void InitalizrHelper::copyFile(const QString& source,const QString& dest){
    QFile::copy(source,dest);
    QFile::setPermissions(dest, QFile::WriteOwner | QFile::WriteUser | QFile::WriteGroup | QFile::WriteOther);
}

void InitalizrHelper::generate(const QString& name,const QString& path){
    if(name.isEmpty()){
        error(tr("The name cannot be empty"));
        return;
    }
    if(path.isEmpty()){
        error(tr("The creation path cannot be empty"));
        return;
    }
    QDir projectRootDir(path);
    if(!projectRootDir.exists()){
        error(tr("The path does not exist"));
        return;
    }
    QString projectPath = projectRootDir.filePath(name);
    QDir projectDir(projectPath);
    if(projectDir.exists()){
        error(tr("%1 folder already exists").arg(name));
        return;
    }
    projectDir.mkpath(projectPath);
    QDir fluentDir(projectDir.filePath("FluentUI"));
    copyDir(QDir(QGuiApplication::applicationDirPath()+"/source"),fluentDir);
    templateToFile(":/example/res/template/CMakeLists.txt.in",projectDir.filePath("CMakeLists.txt"),name);
    templateToFile(":/example/res/template/src/CMakeLists.txt.in",projectDir.filePath("src/CMakeLists.txt"),name);
    templateToFile(":/example/res/template/src/main.cpp.in",projectDir.filePath("src/main.cpp"),name);
    templateToFile(":/example/res/template/src/main.qml.in",projectDir.filePath("src/main.qml"),name);
    templateToFile(":/example/res/template/src/en_US.ts.in",projectDir.filePath("src/"+name+"_en_US.ts"),name);
    templateToFile(":/example/res/template/src/zh_CN.ts.in",projectDir.filePath("src/"+name+"_zh_CN.ts"),name);
    copyFile(":/example/res/template/src/App.qml.in",projectDir.filePath("src/App.qml"));
    copyFile(":/example/res/template/src/qml.qrc.in",projectDir.filePath("src/qml.qrc"));
    copyFile(":/example/res/template/src/logo.ico.in",projectDir.filePath("src/logo.ico"));
    copyFile(":/example/res/template/src/README.md.in",projectDir.filePath("src/README.md"));
    return this->success(projectPath);
}
