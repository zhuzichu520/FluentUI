import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluExpander{

    id:control
    property string code: ""
    headerText: qsTr("Source")
    contentHeight:content.height
    focus: false

    FluCopyableText{
        id:content
        width:parent.width
        text:highlightQmlCode(code)
        textFormat: FluMultilineTextBox.RichText
        padding: 10
        topPadding: 10
        leftPadding: 10
        rightPadding: 10
        bottomPadding: 10
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
            showSuccess(qsTr("The Copy is Successful"))
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
