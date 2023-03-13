#include "FluApp.h"

#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickItem>
#include <QTimer>
#include <QClipboard>
#include "Def.h"


FluApp* FluApp::m_instance = nullptr;

FluApp *FluApp::getInstance()
{
    if(FluApp::m_instance == nullptr){
        FluApp::m_instance = new FluApp;
    }
    return FluApp::m_instance;
}

FluApp::FluApp(QObject *parent)
    : QObject{parent}
{
}

void FluApp::init(QWindow *window,QMap<QString, QVariant> properties){
    this->appWindow = window;
    this->properties = properties;
}

void FluApp::run(){
    navigate(initialRoute());
}

void FluApp::navigate(const QString& route,const QJsonObject& argument){
    if(!routes().contains(route)){
        qErrnoWarning("没有找到当前路由");
        return;
    }
    bool isAppWindow = route == initialRoute();
    FramelessView *view = new FramelessView();
    view->setProperty("argument",argument);
    QMapIterator<QString, QVariant> iterator(properties);
    while (iterator.hasNext()) {
        iterator.next();
        QString key = iterator.key();
        QVariant value = iterator.value();
        view->engine()->rootContext()->setContextProperty(key,value);
    }
    view->setColor(QColor(Qt::transparent));
    QObject::connect(view, &QQuickView::statusChanged, view, [&](QQuickView::Status status) {
        if (status == QQuickView::Status::Ready) {
            Q_EMIT windowReady(view);
            view->moveToScreenCenter();
            view->show();
        }
    });
    view->setSource((routes().value(route).toString()));
    if(isAppWindow){
        QObject::connect(view->engine(), &QQmlEngine::quit, qApp, &QCoreApplication::quit);
        //        QObject::connect(qApp, &QGuiApplication::aboutToQuit, qApp, [&view](){view->setSource({});});
    }else{
        view->closeDeleteLater();
    }
}

bool FluApp::equalsWindow(FramelessView *view,QWindow *window){
    return view->winId() == window->winId();
}

QJsonArray FluApp::awesomelist(const QString& keyword)
{
    QJsonArray arr;
    QMetaEnum enumType = Fluent_Awesome::staticMetaObject.enumerator(Fluent_Awesome::staticMetaObject.indexOfEnumerator("Fluent_AwesomeType"));
    for(int i=0; i < enumType.keyCount(); ++i){
        QString name = enumType.key(i);
        int icon = enumType.value(i);
        if(keyword.isEmpty()){
            QJsonObject obj;
            obj.insert("name",name);
            obj.insert("icon",icon);
            arr.append(obj);
        }else{
            if(name.contains(keyword)){
                QJsonObject obj;
                obj.insert("name",name);
                obj.insert("icon",icon);
                arr.append(obj);
            }
        }
    }
    return arr;
}

void FluApp::clipText(const QString& text){
    QGuiApplication::clipboard()->setText(text);
}
