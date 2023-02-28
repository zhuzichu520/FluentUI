#include "Fluent.h"

#include <QFontDatabase>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQuickWindow>
#include "WindowHelper.h"
#include "FluApp.h"
#include "Def.h"

Fluent* Fluent::m_instance = nullptr;

Fluent *Fluent::getInstance()
{
    if(Fluent::m_instance == nullptr){
        Fluent::m_instance = new Fluent;
    }
    return Fluent::m_instance;
}

QString Fluent::version() const
{
    return QStringLiteral(VERSION_IN);
}

void Fluent::registerTypes(const char *uri){
    Q_INIT_RESOURCE(res);
    int major = 1;
    int minor = 0;

    qmlRegisterType<WindowHelper>(uri,major,minor,"WindowHelper");

    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluShadow.qml"),uri,major,minor,"FluShadow");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTooltip.qml"),uri,major,minor,"FluTooltip");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluDivider.qml"),uri,major,minor,"FluDivider");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluIcon.qml"),uri,major,minor,"FluIcon");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluObject.qml"),uri,major,minor,"FluObject");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluInfoBar.qml"),uri,major,minor,"FluInfoBar");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluWindow.qml"),uri,major,minor,"FluWindow");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluRectangle.qml"),uri,major,minor,"FluRectangle");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluAppBar.qml"),uri,major,minor,"FluAppBar");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluAppBar.qml"),uri,major,minor,"FluAppBar");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluButton.qml"),uri,major,minor,"FluButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluCheckBox.qml"),uri,major,minor,"FluCheckBox");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluComboBox.qml"),uri,major,minor,"FluComboBox");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluDropDownButton.qml"),uri,major,minor,"FluDropDownButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluFilledButton.qml"),uri,major,minor,"FluFilledButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluIconButton.qml"),uri,major,minor,"FluIconButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluProgressBar.qml"),uri,major,minor,"FluProgressBar");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluProgressRing.qml"),uri,major,minor,"FluProgressRing");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluRadioButton.qml"),uri,major,minor,"FluRadioButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluSlider.qml"),uri,major,minor,"FluSlider");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTextBox.qml"),uri,major,minor,"FluTextBox");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluText.qml"),uri,major,minor,"FluText");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTimePicker.qml"),uri,major,minor,"FluTimePicker");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluFilledButton.qml"),uri,major,minor,"FluFilledButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluToggleSwitch.qml"),uri,major,minor,"FluToggleSwitch");

    qmlRegisterUncreatableMetaObject(Fluent_Awesome::staticMetaObject,  uri,major,minor,"FluentIcons", "Access to enums & flags only");
}

void Fluent::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
//    QFont font;
//    font.setFamily("Microsoft YaHei");
//    QGuiApplication::setFont(font);
//    QQuickWindow::setTextRenderType(QQuickWindow::NativeTextRendering);
    QFontDatabase::addApplicationFont(":/com.zhuzichu/res/font/fontawesome-webfont.ttf");
    engine->rootContext()->setContextProperty("FluApp",FluApp::getInstance());
}
