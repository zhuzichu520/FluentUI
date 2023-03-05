#include "InstallHelper.h"

#include <QDir>
#include <QCoreApplication>
#include <QtConcurrent>

#include <windows.h>
#include <shobjidl.h>
#include <shlguid.h>

#pragma comment(lib, "User32.lib")
#pragma comment(lib, "Ole32.lib")

extern Q_CORE_EXPORT int qt_ntfs_permission_lookup;

using CopyProgressCallback = std::function<void(int currentFile, int totalFiles)>;


QString linkName = "FluentUI.lnk";
QString uninstallLinkName = "Uninstall FluentUI.lnk";
QString fileName = "FluentUI";

InstallHelper* InstallHelper::m_instance = nullptr;

static QString getInstallConfigPath(){
    return QStandardPaths::writableLocation(QStandardPaths::ConfigLocation)+"/install";
}


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

static QString generateBatFile()
{
    QDir pathDir(getInstallConfigPath());
    if(!pathDir.exists()){
        pathDir.mkdir(getInstallConfigPath());
    }
    QString filePath = getInstallConfigPath()+"/uninstall.bat";
    QFile batFile(filePath);
    if (!batFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to create bat file: " << batFile.errorString();
        return "";
    }
    QTextStream out(&batFile);
    out << "@echo off\n";
    out << "set PID=%1" << "\n";
    out << "tasklist /FI \"PID eq %PID%\" | find /i \"%PID%\"\n";
    out << "if \"%ERRORLEVEL%\"==\"0\" (\n";
    out << "    taskkill /pid %PID%\n";
    out << "    timeout /t 2 /nobreak >nul\n";
    out << "    echo The process with PID %PID% has been terminated.\n";
    out << ") else (\n";
    out << "    echo The process with PID %PID% does not exist.\n";
    out << ")\n";
    out << "rd /s /q %2" <<"\n";
    batFile.close();
    return filePath;
}

static bool registerUninstallProgram(const QString& displayName, const QString& installPath, const QString& version)
{
    const QString instalIniPath = getInstallConfigPath()+"/install.ini";
    QSettings settings(instalIniPath,QSettings::IniFormat);
    settings.setValue("DisplayName", displayName);
    settings.setValue("InstallLocation", installPath);
    settings.setValue("DisplayVersion", version);
    QString uninstallCommand = QString("\"%1\" --uninstall").arg(QCoreApplication::applicationFilePath());
    settings.setValue("UninstallString", uninstallCommand);
    settings.sync();
    return true;
}

static bool unRegisterUninstallProgram(){
    const QString instalIniPath = getInstallConfigPath()+"/install.ini";
    QFile instalIniFile(instalIniPath);
    if(instalIniFile.exists()){
        instalIniFile.remove();
    }
    return true;
}

static void createHome(const QString& exePath){
    //创建桌面快捷方式
    QFile::link(exePath,QStandardPaths::writableLocation(QStandardPaths::DesktopLocation).append("/").append(linkName));
}

static void removeLink(){
    QString linkPath = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation).append("/").append(linkName);
    QFile linkHome(linkPath);
    if(linkHome.exists()){
        linkHome.remove();
    }
    linkPath = QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation).append("/").append(fileName);
    QFile linkStartMenu(linkPath);
    if(linkStartMenu.exists()){
        linkStartMenu.remove();
    }
}

static void createStartMenu(const QString& exePath){
    QString startMenuPath = QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation).append("/").append(fileName);
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



static void createUninstallLink(QString exePath, QString path){
#ifdef Q_OS_WIN
    QString dst = path.append("\\").append(uninstallLinkName);
    IShellLink *pShellLink;
    QString args = "--uninstall";
    HRESULT hres = CoCreateInstance(CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER,IID_IShellLink, (LPVOID *)&pShellLink);
    if (SUCCEEDED(hres))
    {
        pShellLink->SetPath(exePath.toStdWString().c_str());
        pShellLink->SetArguments(args.toStdWString().c_str());
        pShellLink->SetDescription(L"Fluent Uninstall");
        IPersistFile *pPersistFile;
        hres = pShellLink->QueryInterface(IID_IPersistFile, (LPVOID *)&pPersistFile);
        if (SUCCEEDED(hres))
        {
            hres = pPersistFile->Save(dst.toStdWString().c_str(), TRUE);
            pPersistFile->Release();
        }
        pShellLink->Release();
    }
    CoUninitialize();
#endif
}

InstallHelper *InstallHelper::getInstance()
{
    if(InstallHelper::m_instance == nullptr){
        InstallHelper::m_instance = new InstallHelper;
    }
    return InstallHelper::m_instance;
}

InstallHelper::InstallHelper(QObject *parent)
    : QObject{parent}
{
    installing(false);
    uninstallSuccess(false);
    errorInfo("");
}

bool InstallHelper::isNavigateInstall(){
    const QString instalIniPath = getInstallConfigPath()+"/install.ini";
    QFile installIniFle(instalIniPath);
    if(installIniFle.exists()){
        return false;
    }
    return true;
}

void InstallHelper::install(const QString& path,bool isHome,bool isStartMenu){
    qt_ntfs_permission_lookup ++;
    QFileInfo folder(path.chopped(8));
    bool isWritable = folder.isWritable();
    qt_ntfs_permission_lookup --;
    qDebug()<<folder.path();
    if (!isWritable)
    {
        errorInfo(QString("无写入权限，请用管理员运行或者更新安装文件夹地址"));
        return;
    }
    installing(true);
    QString exePath = path+"\\"+"example.exe";
    QtConcurrent::run([=](){
        QFuture<void> future =  QtConcurrent::run(copyDir,QCoreApplication::applicationDirPath(),path,[=](int currentFile, int totalFiles){
            if(currentFile==totalFiles){
                if(isHome){
                    createHome(exePath);
                }
                if(isStartMenu){
                    createStartMenu(exePath);
                }
                createUninstallLink(exePath,path);
                registerUninstallProgram("FluentUI",path,"1.0.0.0");
            }
        });
        future.waitForFinished();
        QStringList args;
        args<<"/c";
        args<<exePath;
        QProcess::startDetached("cmd.exe",args,"C:/",nullptr);
        QCoreApplication::exit();
    });
}

void InstallHelper::uninstall(){
    QString batFile = generateBatFile();
    qint64 pid = QCoreApplication::applicationPid();
    QString currentDir = QCoreApplication::applicationDirPath().replace("/","\\");
    QStringList args;
    args<<"/c";
    args<<batFile;
    args<<QString::number(pid);
    args<<currentDir;
    removeLink();
    unRegisterUninstallProgram();
    QProcess::startDetached("cmd.exe",args,"C:/",nullptr);
}
