/*
 * MIT License
 *
 * Copyright (C) 2021-2023 by wangwenx190 (Yuhang Zhao)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "log.h"
#include <QtCore/qdebug.h>
#include <QtCore/qfile.h>
#include <QtCore/qtextstream.h>
#include <iostream>
#include <framelesshelpercore_global.h>

#ifndef QT_ENDL
#  if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
#    define QT_ENDL Qt::endl
#  else
#    define QT_ENDL endl
#  endif
#endif

static QString g_app = {};
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
        std::cout << qUtf8Printable(finalMessage) << std::endl;
    } else {
        std::cerr << qUtf8Printable(finalMessage) << std::endl;
    }
    if (g_logError) {
        return;
    }
    if (!g_logFile) {
        g_logFile = std::make_unique<QFile>();
        g_logFile->setFileName(FRAMELESSHELPER_STRING_LITERAL("debug-%1.log").arg(g_app));
        if (!g_logFile->open(QFile::WriteOnly | QFile::Text | QFile::Append)) {
            std::cerr << "Can't open file to write: " << qUtf8Printable(g_logFile->errorString()) << std::endl;
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
    qSetMessagePattern(FRAMELESSHELPER_STRING_LITERAL(
        "[%{time yyyy/MM/dd hh:mm:ss.zzz}] <%{if-info}INFO%{endif}%{if-debug}DEBUG"
        "%{endif}%{if-warning}WARNING%{endif}%{if-critical}CRITICAL%{endif}%{if-fatal}"
        "FATAL%{endif}> %{if-category}%{category}: %{endif}%{message}"));
    qInstallMessageHandler(myMessageHandler);
}
