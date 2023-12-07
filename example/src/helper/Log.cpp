#include "Log.h"
#include <QtCore/qdebug.h>
#include <QtCore/qfile.h>
#include <QtCore/qtextstream.h>
#include <QGuiApplication>
#include <iostream>
#include <QDateTime>
#include <QStandardPaths>
#include <QDir>
#include <QThread>
#include "Version.h"
#ifdef WIN32
#include <process.h>
#else
#include <unistd.h>
#endif

#ifndef QT_ENDL
#  if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
#    define QT_ENDL Qt::endl
#  else
#    define QT_ENDL endl
#  endif
#endif

static QString g_app = {};
static QString g_file_path= {};
static bool g_logError = false;

static std::unique_ptr<QFile> g_logFile = nullptr;
static std::unique_ptr<QTextStream> g_logStream = nullptr;

static int g_logLevel = 4;

std::map<QtMsgType, int> logLevelMap = {
    {QtFatalMsg,0},
    {QtCriticalMsg,1},
    {QtWarningMsg,2},
    {QtInfoMsg,3},
    {QtDebugMsg,4}
};


static inline void myMessageHandler(const QtMsgType type, const QMessageLogContext &context, const QString &message)
{
    if(logLevelMap[type]>g_logLevel){
        return;
    }
    if (!message.isEmpty()) {
        QString levelName;
        switch (type) {
        case QtDebugMsg:
            levelName = QStringLiteral("Debug");
            break;
        case QtInfoMsg:
            levelName = QStringLiteral("Info");
            break;
        case QtWarningMsg:
            levelName = QStringLiteral("Warning");
            break;
        case QtCriticalMsg:
            levelName = QStringLiteral("Critical");
            break;
        case QtFatalMsg:
            levelName = QStringLiteral("Fatal");
            break;
        }
        QString fileAndLineLogStr;
        if(context.file){
            std::string strFileTmp = context.file;
            const char* ptr = strrchr(strFileTmp.c_str(), '/');
            if (nullptr != ptr) {
                char fn[512] = {0};
                sprintf(fn, "%s", ptr + 1);
                strFileTmp = fn;
            }
            const char* ptrTmp = strrchr(strFileTmp.c_str(), '\\');
            if (nullptr != ptrTmp) {
                char fn[512] = {0};
                sprintf(fn, "%s", ptrTmp + 1);
                strFileTmp = fn;
            }
            fileAndLineLogStr = QString::fromStdString("[%1:%2]").arg(QString::fromStdString(strFileTmp),QString::number(context.line));
        }
        const QString finalMessage = QString::fromStdString("%1[%2]%3[%4]:%5").arg(
            QDateTime::currentDateTime().toString("yyyy/MM/dd hh:mm:ss.zzz"),
            levelName,
            fileAndLineLogStr,
            QString::number(reinterpret_cast<quintptr>(QThread::currentThreadId())),
            message);
        if ((type == QtInfoMsg) || (type == QtDebugMsg)) {
            std::cout << qPrintable(finalMessage) << std::endl;
        } else {
            std::cerr << qPrintable(finalMessage) << std::endl;
        }
        if (g_logError) {
            return;
        }
        if (!g_logFile) {
            g_logFile = std::make_unique<QFile>(g_file_path);
            if (!g_logFile->open(QFile::WriteOnly | QFile::Text | QFile::Append)) {
                std::cerr << "Can't open file to write: " << qPrintable(g_logFile->errorString()) << std::endl;
                g_logFile.reset();
                g_logError = true;
                return;
            }
        }
        if (!g_logStream) {
            g_logStream = std::make_unique<QTextStream>();
            g_logStream->setDevice(g_logFile.get());
        }
        (*g_logStream) << finalMessage << QT_ENDL;
        g_logStream->flush();
    }
}

void Log::setup(const QString &app)
{
    Q_ASSERT(!app.isEmpty());
    if (app.isEmpty()) {
        return;
    }
    static bool once = false;
    if (once) {
        return;
    }
    once = true;
    g_app = app;
    const QString logFileName = QString("%1-%2.log").arg(g_app,QString::number(QDateTime::currentMSecsSinceEpoch()));
    const QString logDirPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation)+"/log";
    const QDir logDir(logDirPath);
    if(!logDir.exists()){
        logDir.mkpath(logDirPath);
    }
    g_file_path = logDir.filePath(logFileName);
    qInstallMessageHandler(myMessageHandler);
    qInfo()<<"===================================================";
    qInfo()<<"[AppName]"<<g_app;
    qInfo()<<"[AppVersion]"<<APPLICATION_VERSION;
#ifdef WIN32
    qInfo()<<"[ProcessId]"<<QString::number(_getpid());
#else
    qInfo()<<"[ProcessId]"<<QString::number(getpid());
#endif
    qInfo()<<"[GitHashCode]"<<COMMIT_HASH;
    qInfo()<<"[DeviceInfo]";
    qInfo()<<"  [DeviceId]"<<QSysInfo::machineUniqueId();
    qInfo()<<"  [Manufacturer]"<<QSysInfo::prettyProductName();
    qInfo()<<"  [CPU_ABI]"<<QSysInfo::currentCpuArchitecture();
    qInfo()<<"[LOG_LEVEL]"<<g_logLevel;
    qInfo()<<"[LOG_PATH]"<<g_file_path;
    qInfo()<<"===================================================";
}
