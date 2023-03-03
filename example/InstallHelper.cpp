#include "InstallHelper.h"

#include <QDir>
#include <QCoreApplication>
#include <QtConcurrent>

#include <windows.h>
#include <shobjidl.h>
#include <shlguid.h>

#pragma comment(lib, "User32.lib")
#pragma comment(lib, "Ole32.lib")


using CopyProgressCallback = std::function<void(int currentFile, int totalFiles)>;


static void copyDir(const QString& srcPath, const QString& dstPath, CopyProgressCallback callback)
{
    QDir srcDir(srcPath);
    QDir dstDir(dstPath);
    if (!dstDir.exists()) {
        dstDir.mkdir(dstPath);
    }
    QFileInfoList fileInfos = srcDir.entryInfoList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);
    int totalFiles = fileInfos.count();
    int currentFile = 0;
    foreach (QFileInfo fileInfo, fileInfos) {
        currentFile++;
        QString srcFilePath = fileInfo.filePath();
        QString dstFilePath = dstPath + QDir::separator() + fileInfo.fileName();
        if (fileInfo.isDir()) {
            copyDir(srcFilePath, dstFilePath, callback);
        } else {
            QFile dstFile(dstFilePath);
            if(dstFile.exists()){
                dstFile.remove();
            }
            QFile::copy(srcFilePath, dstFilePath);
        }
        if (callback != nullptr) {
            callback(currentFile, totalFiles);
        }
    }
}

static void createHome(const QString& exePath,const QString& linkName){
    //创建桌面快捷方式
    QFile::link(exePath, QStandardPaths::writableLocation(QStandardPaths::DesktopLocation).append("/").append(linkName));
}

static void createUninstallLink(QString exePath, QString path, QString uninstallLinkName){
#ifdef Q_OS_WIN
    QString dst = path.append("\\").append(uninstallLinkName);
    IShellLink *pShellLink;
    QString args = "--uninstall";
    HRESULT hres = CoCreateInstance(CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER,
                                    IID_IShellLink, (LPVOID *)&pShellLink);
    if (SUCCEEDED(hres))
    {
        // 设置快捷方式的目标路径和参数
        pShellLink->SetPath(exePath.toStdWString().c_str());
        pShellLink->SetArguments(args.toStdWString().c_str());

        // 设置快捷方式的描述
        pShellLink->SetDescription(L"Fluent Uninstall");

        // 获取IPersistFile接口
        IPersistFile *pPersistFile;
        hres = pShellLink->QueryInterface(IID_IPersistFile, (LPVOID *)&pPersistFile);

        if (SUCCEEDED(hres))
        {
            // 保存快捷方式到文件
            hres = pPersistFile->Save(dst.toStdWString().c_str(), TRUE);
            pPersistFile->Release();
        }
        pShellLink->Release();
    }
    CoUninitialize();

    //    std::string dst = path.append("\\").append(uninstallLinkName).toStdString();

    //    QFile::link(exePath,QString::fromStdString(dst + " --uninstall"));
#endif
}

static void createStartMenu(const QString& exePath,const QString& fileName,const QString& linkName){
    //创建开始菜单快捷方式
    QString startMenuPath=QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation).append("/").append(fileName);
    QDir dir(startMenuPath);
    if(!dir.exists())
    {
        dir.mkdir(startMenuPath);
    }
    if(dir.exists())
    {
        QFile::link(exePath, startMenuPath.append("/").append(linkName));
    }
}


InstallHelper::InstallHelper(QObject *parent)
    : QObject{parent}
{
    installing(false);
}

void InstallHelper::install(const QString& path,bool isHome,bool isStartMenu){
    QtConcurrent::run([=](){
        installing(true);
        QFuture<void> future =  QtConcurrent::run(copyDir,QCoreApplication::applicationDirPath(),path,[=](int currentFile, int totalFiles){
            if(currentFile==totalFiles){
                QString exePath = path+"\\"+"example.exe";
                QString fileName = "FluentUI";
                QString linkName = "FluentUI.lnk";
                QString uninstallLinkName = "Uninstall FluentUI.lnk";
                if(isHome){
                    createHome(exePath,linkName);
                }
                if(isStartMenu){
                    createStartMenu(exePath,fileName,linkName);
                }
                createUninstallLink(exePath,path,uninstallLinkName);
            }
        });
        future.waitForFinished();
        qDebug()<<QCoreApplication::applicationDirPath();
        qDebug()<<path;
        installing(false);
    });
}

void InstallHelper::uninstall(){
    QString currentDir = QCoreApplication::applicationDirPath();
    QDir dir(currentDir);
    dir.removeRecursively();
}
