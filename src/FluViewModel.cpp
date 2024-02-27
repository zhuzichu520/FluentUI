#include "FluViewModel.h"

#include <QQuickItem>
#include "Def.h"

FluViewModelManager::FluViewModelManager(QObject *parent): QObject{parent}{
}

void FluViewModelManager::insertViewModel(FluViewModel* value){
    _viewmodel.append(value);
}

void FluViewModelManager::deleteViewModel(FluViewModel* value){
    _viewmodel.removeOne(value);
}

QObject* FluViewModelManager::getModel(const QString& key){
    return  _data.value(key);
}

void FluViewModelManager::insert(const QString& key,QObject* value){
    _data.insert(key,value);
}

bool FluViewModelManager::exist(const QString& key){
    return _data.contains(key);
}

void FluViewModelManager::refreshViewModel(FluViewModel* viewModel,QString key,QVariant value){
    foreach (auto item, _viewmodel) {
        if(item->getKey() == viewModel->getKey()){
            item->enablePropertyChange = false;
            item->setProperty(key.toLatin1().constData(),value);
            item->enablePropertyChange  = true;
        }
    }
}

FluPropertyObserver::FluPropertyObserver(QString name,QObject* model,QObject *parent):QObject{parent}{
    _name = name;
    _model = model;
    _property = QQmlProperty(parent,_name);
    _property.connectNotifySignal(this,SLOT(_propertyChange()));
}

FluPropertyObserver::~FluPropertyObserver(){
}

void FluPropertyObserver::_propertyChange(){
    auto viewModel = (FluViewModel*)parent();
    if(viewModel->enablePropertyChange){
        auto value = _property.read();
        _model->setProperty(_name.toLatin1().constData(),value);
        FluViewModelManager::getInstance()->refreshViewModel(viewModel,_name,value);
    }
}

FluViewModel::FluViewModel(QObject *parent):QObject{parent}{
    scope(FluViewModelType::Scope::Window);
    FluViewModelManager::getInstance()->insertViewModel(this);
}

FluViewModel::~FluViewModel(){
    FluViewModelManager::getInstance()->deleteViewModel(this);
}

void FluViewModel::classBegin(){
}

void FluViewModel::componentComplete(){
    auto o = parent();
    while (nullptr != o) {
        _window = o;
        o = o->parent();
    }
    const QMetaObject* obj = metaObject();
    if(_scope == FluViewModelType::Scope::Window){
        _key = property("objectName").toString()+"-"+QString::number(reinterpret_cast<qulonglong>(_window), 16);
    }else{
        _key = property("objectName").toString();
    }
    QObject * model;
    if(!FluViewModelManager::getInstance()->exist(_key)){
        if(_scope == FluViewModelType::Scope::Window){
            model = new QObject(_window);
        }else{
            model = new QObject();
        }
        Q_EMIT initData();
        for (int i = 0; i < obj->propertyCount(); ++i) {
            const QMetaProperty property = obj->property(i);
            QString propertyName = property.name();
            auto value = property.read(this);
            model->setProperty(propertyName.toLatin1().constData(),value);
            new FluPropertyObserver(propertyName,model,this);
        }
        FluViewModelManager::getInstance()->insert(_key,model);
    }else{
        model = FluViewModelManager::getInstance()->getModel(_key);
        for (int i = 0; i < obj->propertyCount(); ++i) {
            const QMetaProperty property = obj->property(i);
            QString propertyName = property.name();
            new FluPropertyObserver(propertyName,model,this);
        }
    }
    foreach (auto key, model->dynamicPropertyNames()) {
        setProperty(key,model->property(key));
    }
}

QString FluViewModel::getKey(){
    return _key;
}
