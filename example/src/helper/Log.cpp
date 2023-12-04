#include "Log.h"
#include <QtCore/qdebug.h>
#include <QtCore/qfile.h>
#include <QtCore/qtextstream.h>
#include <iostream>
#include <QStandardPaths>
#include <QDir>

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

static inline void myMessageHandler(const QtMsgType type, const QMessageLogContext &context, const QString &message)
{
    if (message.isEmpty()) {
        return;
    }
    const QString finalMessage = qFormatLogMessage(type, context, message).trimmed();
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
    const QString logFileName = QString("debug-%1.log").arg(g_app);
    const QString logDirPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    const QDir logDir(logDirPath);
    if(!logDir.exists()){
        logDir.mkpath(logDirPath);
    }
    g_file_path = logDir.filePath(logFileName);
    qSetMessagePattern(QString(
        "[%{time yyyy/MM/dd hh:mm:ss.zzz}] <%{if-info}INFO%{endif}%{if-debug}DEBUG"
        "%{endif}%{if-warning}WARNING%{endif}%{if-critical}CRITICAL%{endif}%{if-fatal}"
        "FATAL%{endif}> %{if-category}%{category}: %{endif}%{message}"));
    qInstallMessageHandler(myMessageHandler);
    qDebug()<<"Application log file path->"<<g_file_path;
}
