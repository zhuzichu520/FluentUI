#include "Fluent.h"

#include <QFontDatabase>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQuickWindow>
#include "FluColors.h"
#include "FluTheme.h"
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
    qmlRegisterType<FluColorSet>(uri,major,minor,"FluColorSet");

    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluPivotItem.qml"),uri,major,minor,"FluPivotItem");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluPivot.qml"),uri,major,minor,"FluPivot");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluFlipView.qml"),uri,major,minor,"FluFlipView");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluPaneItemExpander.qml"),uri,major,minor,"FluPaneItemExpander");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTabView.qml"),uri,major,minor,"FluTabView");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluArea.qml"),uri,major,minor,"FluArea");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluBadge.qml"),uri,major,minor,"FluBadge");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluMediaPlayer.qml"),uri,major,minor,"FluMediaPlayer");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluContentPage.qml"),uri,major,minor,"FluContentPage");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluScrollablePage.qml"),uri,major,minor,"FluScrollablePage");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluPaneItemHeader.qml"),uri,major,minor,"FluPaneItemHeader");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluPaneItem.qml"),uri,major,minor,"FluPaneItem");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluPaneItemSeparator.qml"),uri,major,minor,"FluPaneItemSeparator");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluNavigationView.qml"),uri,major,minor,"FluNavigationView");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluCalendarPicker.qml"),uri,major,minor,"FluCalendarPicker");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluCalendarView.qml"),uri,major,minor,"FluCalendarView");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluDatePicker.qml"),uri,major,minor,"FluDatePicker");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTimePicker.qml"),uri,major,minor,"FluTimePicker");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluColorView.qml"),uri,major,minor,"FluColorView");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluColorPicker.qml"),uri,major,minor,"FluColorPicker");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluCarousel.qml"),uri,major,minor,"FluCarousel");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluAutoSuggestBox.qml"),uri,major,minor,"FluAutoSuggestBox");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluExpander.qml"),uri,major,minor,"FluExpander");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTreeView.qml"),uri,major,minor,"FluTreeView");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluContentDialog.qml"),uri,major,minor,"FluContentDialog");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluMenuItem.qml"),uri,major,minor,"FluMenuItem");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluMenu.qml"),uri,major,minor,"FluMenu");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluScrollBar.qml"),uri,major,minor,"FluScrollBar");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTextButton.qml"),uri,major,minor,"FluTextButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluMultilineTextBox.qml"),uri,major,minor,"FluMultilineTextBox");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluTooltip.qml"),uri,major,minor,"FluTooltip");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluDivider.qml"),uri,major,minor,"FluDivider");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluIcon.qml"),uri,major,minor,"FluIcon");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluObject.qml"),uri,major,minor,"FluObject");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluInfoBar.qml"),uri,major,minor,"FluInfoBar");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluWindow.qml"),uri,major,minor,"FluWindow");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluRectangle.qml"),uri,major,minor,"FluRectangle");
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
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluFilledButton.qml"),uri,major,minor,"FluFilledButton");
    qmlRegisterType(QUrl("qrc:/com.zhuzichu/controls/FluToggleSwitch.qml"),uri,major,minor,"FluToggleSwitch");

    qmlRegisterUncreatableMetaObject(Fluent_Awesome::staticMetaObject,  uri,major,minor,"FluentIcons", "Access to enums & flags only");
}

void Fluent::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(engine)
    Q_UNUSED(uri)
#ifdef Q_OS_WIN
    QFont font;
    font.setFamily("Microsoft YaHei");
    QGuiApplication::setFont(font);
    //    QQuickWindow::setTextRenderType(QQuickWindow::NativeTextRendering);
#endif
    QFontDatabase::addApplicationFont(":/com.zhuzichu/res/font/Segoe_Fluent_Icons.ttf");
    FluApp* app = FluApp::getInstance();
    engine->rootContext()->setContextProperty("FluApp",app);
    FluColors* colors = FluColors::getInstance();
    engine->rootContext()->setContextProperty("FluColors",colors);
    FluTheme* theme = FluTheme::getInstance();
    engine->rootContext()->setContextProperty("FluTheme",theme);
}
