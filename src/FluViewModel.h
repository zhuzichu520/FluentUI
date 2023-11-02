#ifndef FLUVIEWMODEL_H
#define FLUVIEWMODEL_H

#include <QQuickItem>
#include <QtQml/qqml.h>
#include <QQuickWindow>
#include <QQmlProperty>
#include "stdafx.h"
#include "singleton.h"

class Model : public QObject{
    Q_OBJECT
public:
    explicit Model(QObject *parent = nullptr);
    ~Model();
};

class FluViewModel : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY_AUTO(int,scope);
    QML_NAMED_ELEMENT(FluViewModel)
public:
    explicit FluViewModel(QObject *parent = nullptr);
    ~FluViewModel();
    void classBegin() override;
    void componentComplete() override;
    Q_SIGNAL void initData();
    QString getKey();
    bool enablePropertyChange = true;
private:
    QObject* _window = nullptr;
    QString _key = "";
};

class PropertyObserver: public QObject{
    Q_OBJECT
public:
    explicit PropertyObserver(QString name,QObject* model,QObject *parent = nullptr);
    ~PropertyObserver();
private:
    Q_SLOT void _propertyChange();
private:
    QString _name = "";
    QQmlProperty _property;
    QObject* _model = nullptr;
};


class ViewModelManager:public QObject{
    Q_OBJECT
private:
    explicit ViewModelManager(QObject *parent = nullptr);
public:
    SINGLETONG(ViewModelManager)
    bool exist(const QString& key);
    void insert(const QString& key,QObject* value);
    QObject* getModel(const QString& key);
    void insertViewModel(FluViewModel* value);
    void deleteViewModel(FluViewModel* value);
    void refreshViewModel(FluViewModel* viewModel,QString key,QVariant value);
private:
    QMap<QString,QObject*> _data;
    QList<FluViewModel*> _viewmodel;
};

#endif // FLUVIEWMODEL_H
