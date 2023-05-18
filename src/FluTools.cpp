#include "FluTools.h"
#include <QGuiApplication>
#include <QClipboard>
#include <QUuid>

FluTools* FluTools::m_instance = nullptr;

FluTools *FluTools::getInstance()
{
    if(FluTools::m_instance == nullptr){
        FluTools::m_instance = new FluTools;
    }
    return FluTools::m_instance;
}


FluTools::FluTools(QObject *parent)
    : QObject{parent}
{

}

void FluTools::clipText(const QString& text){
    QGuiApplication::clipboard()->setText(text);
}

QString FluTools::uuid(){
    return QUuid::createUuid().toString();
}

QString FluTools::readFile(const QString &fileName)
{
    QString content;
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        content = stream.readAll();
    }
    return content;
}

bool FluTools::isMacos(){
#if defined(Q_OS_MACOS)
    return true;
#else
    return false;
#endif
}

bool FluTools::isLinux(){
#if defined(Q_OS_LINUX)
    return true;
#else
    return false;
#endif
}

bool FluTools::isWin(){
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}


