#include "InitalizrHelper.h"

#include <QDir>

InitalizrHelper::InitalizrHelper(QObject *parent) : QObject(parent)
{

}

InitalizrHelper::~InitalizrHelper() = default;


void InitalizrHelper::generate(const QString& name,const QString& path){
    if(name.isEmpty()){
        error(tr("The name cannot be empty"));
        return;
    }
    if(path.isEmpty()){
        error(tr("The creation path cannot be empty"));
        return;
    }
    QDir projectDir(path);
    if(!projectDir.exists()){
        error(tr("The path does not exist"));
        return;
    }
    return success();
}
