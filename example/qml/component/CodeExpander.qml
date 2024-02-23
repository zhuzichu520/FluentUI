import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluExpander{

    id:control
    property string code: ""
    headerText: "Source"
    contentHeight:content.height
    focus: false

    FluMultilineTextBox{
        id:content
        width:parent.width
        activeFocusOnTab: false
        activeFocusOnPress: false
        readOnly: true
        text:highlightQmlCode(code)
        textFormat: FluMultilineTextBox.RichText
        KeyNavigation.priority: KeyNavigation.BeforeItem
        background:Rectangle{
            radius: 4
            color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            border.color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
            border.width: 1
        }
    }

    FluIconButton{
        iconSource:FluentIcons.Copy
        anchors{
            right: parent.right
            top: parent.top
            rightMargin: 5
            topMargin: 5
        }
        onClicked:{
            FluTools.clipText(FluTools.html2PlantText(content.text))
            showSuccess("复制成功")
        }
    }

    function htmlEncode(e){
        var i,s;
        for(i in s={
                "&":/&/g,//""//":/"/g,"'":/'/g,
                "<":/</g,">":/>/g,"<br/>":/\n/g,
                " ":/ /g,"  ":/\t/g
            })e=e.replace(s[i],i);
        return e;
    }

    function highlightQmlCode(code) {
        // 定义 QML 关键字列表
        var qmlKeywords = [
                    "FluTextButton",
                    "FluAppBar",
                    "FluAutoSuggestBox",
                    "FluBadge",
                    "FluButton",
                    "FluCalendarPicker",
                    "FluCalendarView",
                    "FluCarousel",
                    "FluCheckBox",
                    "FluColorPicker",
                    "FluColorView",
                    "FluComboBox",
                    "FluContentDialog",
                    "FluContentPage",
                    "FluDatePicker",
                    "FluDivider",
                    "FluDropDownButton",
                    "FluExpander",
                    "FluFilledButton",
                    "FluFlipView",
                    "FluFocusRectangle",
                    "FluIcon",
                    "FluIconButton",
                    "FluInfoBar",
                    "FluMediaPlayer",
                    "FluMenu",
                    "FluMenuItem",
                    "FluMultilineTextBox",
                    "FluNavigationView",
                    "FluObject",
                    "FluPaneItem",
                    "FluPaneItemExpander",
                    "FluPaneItemHeader",
                    "FluPaneItemSeparator",
                    "FluPivot",
                    "FluPivotItem",
                    "FluProgressBar",
                    "FluProgressRing",
                    "FluRadioButton",
                    "FluRectangle",
                    "FluScrollablePage",
                    "FluScrollBar",
                    "FluShadow",
                    "FluSlider",
                    "FluTabView",
                    "FluText",
                    "FluTextArea",
                    "FluTextBox",
                    "FluTextBoxBackground",
                    "FluTextBoxMenu",
                    "FluTextButton",
                    "FluTextFiled",
                    "FluTimePicker",
                    "FluToggleSwitch",
                    "FluTooltip",
                    "FluTreeView",
                    "FluWindow",
                    "FluWindowResize",
                    "FluToggleButton",
                    "FluTableView",
                    "FluColors",
                    "FluTheme",
                    "FluStatusLayout",
                    "FluRatingControl",
                    "FluPasswordBox",
                    "FluBreadcrumbBar",
                    "FluCopyableText",
                    "FluAcrylic",
                    "FluRemoteLoader",
                    "FluMenuBar",
                    "FluPagination",
                    "FluRadioButtons",
                    "FluImage",
                    "FluSpinBox",
                    "FluWatermark",
                    "FluTour",
                    "FluQRCode",
                    "FluTimeline",
                    "FluChart",
                    "FluRangeSlider",
                    "FluStaggeredLayout",
                    "FluProgressButton",
                    "FluLoadingButton",
                    "FluClip",
                    "FluNetwork",
                    "FluShortcutPicker"
                ];
        code = code.replace(/\n/g, "<br>");
        code = code.replace(/ /g, "&nbsp;");
        return code.replace(RegExp("\\b(" + qmlKeywords.join("|") + ")\\b", "g"), "<span style='color: #c23a80'>$1</span>");
    }
}
