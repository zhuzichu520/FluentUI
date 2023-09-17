#include "FluViewModel.h"

#include <QQuickItem>
#include "Def.h"

Model::Model(QObject *parent):QObject{parent}{
}

Model::~Model(){
}

ViewModelManager::ViewModelManager(QObject *parent): QObject{parent}{
}

void ViewModelManager::insertViewModel(FluViewModel* value){
    _viewmodel.append(value);
}

void ViewModelManager::deleteViewModel(FluViewModel* value){
    _viewmodel.removeOne(value);
}

QObject* ViewModelManager::getModel(const QString& key){
    return  _data.value(key);
}

void ViewModelManager::insert(const QString& key,QObject* value){
    _data.insert(key,value);
}

bool ViewModelManager::exist(const QString& key){
    return _data.contains(key);
}

void ViewModelManager::refreshViewModel(FluViewModel* viewModel,QString key,QVariant value){
    foreach (auto item, _viewmodel) {
        if(item->getKey() == viewModel->getKey()){
            item->setProperty(key.toStdString().c_str(),value);
        }
    }
}

PropertyObserver::PropertyObserver(QString name,QObject* model,QObject *parent):QObject{parent}{
    _name = name;
    _model = model;
    _property = QQmlProperty(parent,_name);
    _property.connectNotifySignal(this,SLOT(_propertyChange()));
}

PropertyObserver::~PropertyObserver(){
}

void PropertyObserver::_propertyChange(){
    auto value = _property.read();
    _model->setProperty(_name.toStdString().c_str(),value);
    ViewModelManager::getInstance()->refreshViewModel((FluViewModel*)parent(),_name,value);
}

FluViewModel::FluViewModel(QObject *parent):QObject{parent}{
    scope(FluViewModelType::Scope::Window);
    target(nullptr);
    ViewModelManager::getInstance()->insertViewModel(this);
}

FluViewModel::~FluViewModel(){
    ViewModelManager::getInstance()->deleteViewModel(this);
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
        _key = property("objectName_").toString()+QString::number(reinterpret_cast<qulonglong>(_window), 16);
    }else{
        _key = property("objectName").toString();
    }
    QObject * model;
    if(!ViewModelManager::getInstance()->exist(_key)){
        if(_scope == FluViewModelType::Scope::Window){
            model = new Model(_window);
        }else{
            model = new Model();
        }
        Q_EMIT initData();
        for (int i = 0; i < obj->propertyCount(); ++i) {
            const QMetaProperty property = obj->property(i);
            QString propertyName = property.name();
            auto value = property.read(this);
            model->setProperty(propertyName.toStdString().c_str(),value);
            new PropertyObserver(propertyName,model,this);
        }
        ViewModelManager::getInstance()->insert(_key,model);
    }else{
        model = ViewModelManager::getInstance()->getModel(_key);
        for (int i = 0; i < obj->propertyCount(); ++i) {
            const QMetaProperty property = obj->property(i);
            QString propertyName = property.name();
            new PropertyObserver(propertyName,model,this);
        }
    }
    foreach (auto key, model->dynamicPropertyNames()) {
        setProperty(key,model->property(key));
    }
}

QString FluViewModel::getKey(){
    return _key;
}
