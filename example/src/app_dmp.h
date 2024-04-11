#pragma once

#include <Windows.h>
#include <DbgHelp.h>
#include <QDateTime>
#include <QDir>
#include <QGuiApplication>
#include <QProcess>
#include <QStandardPaths>
#include <QString>

#pragma comment(lib, "Dbghelp.lib")

static void
miniDumpWriteDump(HANDLE hProcess, DWORD ProcessId, HANDLE hFile, CONST PMINIDUMP_EXCEPTION_INFORMATION ExceptionParam, CONST PMINIDUMP_CALLBACK_INFORMATION CallbackParam) {
    typedef HRESULT (WINAPI *MiniDumpWriteDumpPtr)(HANDLE hProcess, DWORD ProcessId, HANDLE hFile, MINIDUMP_TYPE DumpType, CONST PMINIDUMP_EXCEPTION_INFORMATION ExceptionParam,
                                                   CONST PMINIDUMP_USER_STREAM_INFORMATION UserStreamParam, CONST PMINIDUMP_CALLBACK_INFORMATION CallbackParam);
    HMODULE module = LoadLibraryW(L"Dbghelp.dll");
    if (module) {
        MiniDumpWriteDumpPtr mini_dump_write_dump;
        mini_dump_write_dump = reinterpret_cast<MiniDumpWriteDumpPtr>(GetProcAddress(module, "MiniDumpWriteDump"));
        if (mini_dump_write_dump) {
            mini_dump_write_dump(hProcess, ProcessId, hFile, static_cast<MINIDUMP_TYPE>(80), ExceptionParam, nullptr, CallbackParam);
        }
    }
}

BOOL CALLBACK MyMiniDumpCallback(PVOID, const PMINIDUMP_CALLBACK_INPUT input, PMINIDUMP_CALLBACK_OUTPUT output) {
    if (input == nullptr || output == nullptr)
        return FALSE;

    BOOL ret = FALSE;
    switch (input->CallbackType) {
        case IncludeModuleCallback:
        case IncludeThreadCallback:
        case ThreadCallback:
        case ThreadExCallback:
            ret = TRUE;
            break;
        case ModuleCallback: {
            if (!(output->ModuleWriteFlags & ModuleReferencedByMemory)) {
                output->ModuleWriteFlags &= ~ModuleWriteModule;
            }
            ret = TRUE;
        }
            break;
        default:
            break;
    }
    return ret;
}

void WriteDump(EXCEPTION_POINTERS *exp, const std::wstring &path) {
    HANDLE h = ::CreateFileW(path.c_str(), GENERIC_WRITE | GENERIC_READ, FILE_SHARE_WRITE | FILE_SHARE_READ, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    MINIDUMP_EXCEPTION_INFORMATION info;
    info.ThreadId = ::GetCurrentThreadId();
    info.ExceptionPointers = exp;
    info.ClientPointers = FALSE;
    MINIDUMP_CALLBACK_INFORMATION mci;
    mci.CallbackRoutine = (MINIDUMP_CALLBACK_ROUTINE) MyMiniDumpCallback;
    mci.CallbackParam = nullptr;
    miniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(), h, &info, &mci);
    ::CloseHandle(h);
}

LONG WINAPI MyUnhandledExceptionFilter(EXCEPTION_POINTERS *exp) {
    const QString dumpFileName = QString("%1_%2.dmp").arg("crash", QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss"));
    const QString dumpDirPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/dmp";
    const QDir dumpDir(dumpDirPath);
    if (!dumpDir.exists()) {
        dumpDir.mkpath(dumpDirPath);
    }
    QString dumpFilePath = dumpDir.filePath(dumpFileName);
    WriteDump(exp, dumpFilePath.toStdWString());
    QStringList arguments;
    arguments << "-crashed=" + dumpFilePath;
    QProcess::startDetached(QGuiApplication::applicationFilePath(), arguments);
    return EXCEPTION_EXECUTE_HANDLER;
}