#include "FluentUI.h"

#include <QGuiApplication>
#include "WindowHelper.h"
#include "Def.h"
#include "FluApp.h"
#include "FluColors.h"
#include "FluTheme.h"
#include "FluTools.h"
#include "FluTextStyle.h"
#include "FluHttp.h"
#include "FluHttpInterceptor.h"
#include "FluWatermark.h"
#include "FluCaptcha.h"
#include "FluEventBus.h"
#include "FluViewModel.h"
#include "Screenshot.h"
#include "QRCode.h"

int major = 1;
int minor = 0;
auto uri = "FluentUI";

FluentUI* FluentUI::m_instance = nullptr;

FluentUI *FluentUI::getInstance()
{
    if(FluentUI::m_instance == nullptr){
        FluentUI::m_instance = new FluentUI;
    }
    return FluentUI::m_instance;
}

void FluentUI::registerTypes(QQmlEngine *engine){
    initializeEngine(engine,uri);
    registerTypes(uri);
}

void FluentUI::registerTypes(const char *uri){
#if (QT_VERSION < QT_VERSION_CHECK(6, 2, 0))
    Q_INIT_RESOURCE(fluentui);
#endif
    qmlRegisterType<WindowHelper>(uri,major,minor,"WindowHelper");
    qmlRegisterType<QRCode>(uri,major,minor,"QRCode");
    qmlRegisterType<FluCaptcha>(uri,major,minor,"FluCaptcha");
    qmlRegisterType<FluWatermark>(uri,major,minor,"FluWatermark");
    qmlRegisterType<ScreenshotBackground>(uri,major,minor,"ScreenshotBackground");
    qmlRegisterType<Screenshot>(uri,major,minor,"Screenshot");
    qmlRegisterType<FluColorSet>(uri,major,minor,"FluColorSet");
    qmlRegisterType<FluHttpInterceptor>(uri,major,minor,"FluHttpInterceptor");
    qmlRegisterType<FluHttp>(uri,major,minor,"FluHttp");
    qmlRegisterType<HttpCallable>(uri,major,minor,"HttpCallable");
    qmlRegisterType<HttpRequest>(uri,major,minor,"HttpRequest");
    qmlRegisterType<FluEvent>(uri,major,minor,"FluEvent");
    qmlRegisterType<FluViewModel>(uri,major,minor,"FluViewModel");

    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/ColorPicker/ColorPicker.qml"),uri,major,minor,"ColorPicker");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/ColorPicker/Content/Checkerboard.qml"),uri,major,minor,"Checkerboard");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/ColorPicker/Content/ColorSlider.qml"),uri,major,minor,"ColorSlider");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/ColorPicker/Content/NumberBox.qml"),uri,major,minor,"NumberBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/ColorPicker/Content/PanelBorder.qml"),uri,major,minor,"PanelBorder");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/ColorPicker/Content/SBPicker.qml"),uri,major,minor,"SBPicker");

    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluAcrylic.qml"),uri,major,minor,"FluAcrylic");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluAppBar.qml"),uri,major,minor,"FluAppBar");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluArea.qml"),uri,major,minor,"FluArea");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluAutoSuggestBox.qml"),uri,major,minor,"FluAutoSuggestBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluBadge.qml"),uri,major,minor,"FluBadge");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluBreadcrumbBar.qml"),uri,major,minor,"FluBreadcrumbBar");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluButton.qml"),uri,major,minor,"FluButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluCalendarPicker.qml"),uri,major,minor,"FluCalendarPicker");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluCalendarView.qml"),uri,major,minor,"FluCalendarView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluCarousel.qml"),uri,major,minor,"FluCarousel");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluChart.qml"),uri,major,minor,"FluChart");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluCheckBox.qml"),uri,major,minor,"FluCheckBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluColorPicker.qml"),uri,major,minor,"FluColorPicker");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluColorView.qml"),uri,major,minor,"FluColorView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluComboBox.qml"),uri,major,minor,"FluComboBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluContentDialog.qml"),uri,major,minor,"FluContentDialog");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluContentPage.qml"),uri,major,minor,"FluContentPage");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluControl.qml"),uri,major,minor,"FluControl");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluCopyableText.qml"),uri,major,minor,"FluCopyableText");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluDatePicker.qml"),uri,major,minor,"FluDatePicker");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluDivider.qml"),uri,major,minor,"FluDivider");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluDropDownButton.qml"),uri,major,minor,"FluDropDownButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluExpander.qml"),uri,major,minor,"FluExpander");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluFilledButton.qml"),uri,major,minor,"FluFilledButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluFlipView.qml"),uri,major,minor,"FluFlipView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluFocusRectangle.qml"),uri,major,minor,"FluFocusRectangle");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluIcon.qml"),uri,major,minor,"FluIcon");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluIconButton.qml"),uri,major,minor,"FluIconButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluImage.qml"),uri,major,minor,"FluImage");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluInfoBar.qml"),uri,major,minor,"FluInfoBar");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluItem.qml"),uri,major,minor,"FluItem");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluItemDelegate.qml"),uri,major,minor,"FluItemDelegate");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluMenu.qml"),uri,major,minor,"FluMenu");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluMenuBar.qml"),uri,major,minor,"FluMenuBar");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluMenuBarItem.qml"),uri,major,minor,"FluMenuBarItem");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluMenuItem.qml"),uri,major,minor,"FluMenuItem");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluMenuSeparator.qml"),uri,major,minor,"FluMenuSeparator");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluMultilineTextBox.qml"),uri,major,minor,"FluMultilineTextBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluNavigationView.qml"),uri,major,minor,"FluNavigationView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluObject.qml"),uri,major,minor,"FluObject");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPage.qml"),uri,major,minor,"FluPage");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPagination.qml"),uri,major,minor,"FluPagination");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPaneItem.qml"),uri,major,minor,"FluPaneItem");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPaneItemEmpty.qml"),uri,major,minor,"FluPaneItemEmpty");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPaneItemExpander.qml"),uri,major,minor,"FluPaneItemExpander");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPaneItemHeader.qml"),uri,major,minor,"FluPaneItemHeader");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPaneItemSeparator.qml"),uri,major,minor,"FluPaneItemSeparator");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPasswordBox.qml"),uri,major,minor,"FluPasswordBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPivot.qml"),uri,major,minor,"FluPivot");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPivotItem.qml"),uri,major,minor,"FluPivotItem");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluPopup.qml"),uri,major,minor,"FluPopup");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluProgressBar.qml"),uri,major,minor,"FluProgressBar");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluProgressRing.qml"),uri,major,minor,"FluProgressRing");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluQRCode.qml"),uri,major,minor,"FluQRCode");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluRadioButton.qml"),uri,major,minor,"FluRadioButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluRadioButtons.qml"),uri,major,minor,"FluRadioButtons");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluRatingControl.qml"),uri,major,minor,"FluRatingControl");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluRectangle.qml"),uri,major,minor,"FluRectangle");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluRemoteLoader.qml"),uri,major,minor,"FluRemoteLoader");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluScreenshot.qml"),uri,major,minor,"FluScreenshot");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluScrollBar.qml"),uri,major,minor,"FluScrollBar");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluScrollIndicator.qml"),uri,major,minor,"FluScrollIndicator");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluScrollablePage.qml"),uri,major,minor,"FluScrollablePage");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluShadow.qml"),uri,major,minor,"FluShadow");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluSlider.qml"),uri,major,minor,"FluSlider");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluSpinBox.qml"),uri,major,minor,"FluSpinBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluStatusView.qml"),uri,major,minor,"FluStatusView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTabView.qml"),uri,major,minor,"FluTabView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTableModelColumn.qml"),uri,major,minor,"FluTableModelColumn");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTableView.qml"),uri,major,minor,"FluTableView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluText.qml"),uri,major,minor,"FluText");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTextBox.qml"),uri,major,minor,"FluTextBox");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTextBoxBackground.qml"),uri,major,minor,"FluTextBoxBackground");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTextBoxMenu.qml"),uri,major,minor,"FluTextBoxMenu");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTextButton.qml"),uri,major,minor,"FluTextButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTimePicker.qml"),uri,major,minor,"FluTimePicker");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTimeline.qml"),uri,major,minor,"FluTimeline");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluToggleButton.qml"),uri,major,minor,"FluToggleButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluToggleSwitch.qml"),uri,major,minor,"FluToggleSwitch");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTooltip.qml"),uri,major,minor,"FluTooltip");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTour.qml"),uri,major,minor,"FluTour");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluTreeView.qml"),uri,major,minor,"FluTreeView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluWindow.qml"),uri,major,minor,"FluWindow");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluRangeSlider.qml"),uri,major,minor,"FluRangeSlider");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluStaggeredView.qml"),uri,major,minor,"FluStaggeredView");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluProgressButton.qml"),uri,major,minor,"FluProgressButton");
    qmlRegisterType(QUrl("qrc:/qt/qml/FluentUI/Controls/FluLoadingButton.qml"),uri,major,minor,"FluLoadingButton");

    qmlRegisterUncreatableMetaObject(Fluent_Awesome::staticMetaObject,  uri,major,minor,"FluentIcons", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluHttpType::staticMetaObject,  uri,major,minor,"FluHttpType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluThemeType::staticMetaObject,  uri,major,minor,"FluThemeType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluPageType::staticMetaObject,  uri,major,minor,"FluPageType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluWindowType::staticMetaObject,  uri,major,minor,"FluWindowType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTreeViewType::staticMetaObject,  uri,major,minor,"FluTreeViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluStatusViewType::staticMetaObject,  uri,major,minor,"FluStatusViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluContentDialogType::staticMetaObject,  uri,major,minor,"FluContentDialogType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTimePickerType::staticMetaObject,  uri,major,minor,"FluTimePickerType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluCalendarViewType::staticMetaObject,  uri,major,minor,"FluCalendarViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTabViewType::staticMetaObject,  uri,major,minor,"FluTabViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluNavigationViewType::staticMetaObject,  uri,major,minor,"FluNavigationViewType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluTimelineType::staticMetaObject,  uri,major,minor,"FluTimelineType", "Access to enums & flags only");
    qmlRegisterUncreatableMetaObject(FluScreenshotType::staticMetaObject,  uri,major,minor,"FluScreenshotType", "Access to enums & flags only");

    qmlRegisterModule(uri,major,minor);
}

void FluentUI::initializeEngine(QQmlEngine *engine, const char *uri){
#ifdef Q_OS_WIN
    QFont font;
    font.setFamily("Microsoft YaHei");
    QGuiApplication::setFont(font);
#endif
    FluApp* app = FluApp::getInstance();
    engine->rootContext()->setContextProperty("FluApp",app);
    FluColors* colors = FluColors::getInstance();
    engine->rootContext()->setContextProperty("FluColors",colors);
    FluTheme* theme = FluTheme::getInstance();
    engine->rootContext()->setContextProperty("FluTheme",theme);
    FluTools* tools = FluTools::getInstance();
    engine->rootContext()->setContextProperty("FluTools",tools);
    FluTextStyle* textStyle = FluTextStyle::getInstance();
    engine->rootContext()->setContextProperty("FluTextStyle",textStyle);
    FluEventBus* eventBus = FluEventBus::getInstance();
    engine->rootContext()->setContextProperty("FluEventBus",eventBus);
    engine->addImportPath("qrc:/qt/qml");
}
