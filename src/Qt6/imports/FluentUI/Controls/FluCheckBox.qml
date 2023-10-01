import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Button {
    property bool disabled: false
    property string contentDescription: ""
    property color borderNormalColor: FluTheme.dark ? Qt.rgba(160/255,160/255,160/255,1) : Qt.rgba(136/255,136/255,136/255,1)
    property color bordercheckedColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color borderHoverColor: FluTheme.dark ? Qt.rgba(167/255,167/255,167/255,1) : Qt.rgba(135/255,135/255,135/255,1)
    property color borderDisableColor: FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
    property color borderPressedColor: FluTheme.dark ? Qt.rgba(90/255,90/255,90/255,1) : Qt.rgba(191/255,191/255,191/255,1)
    property color normalColor: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(247/255,247/255,247/255,1)
    property color checkedColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color hoverColor: FluTheme.dark ? Qt.rgba(72/255,72/255,72/255,1) : Qt.rgba(236/255,236/255,236/255,1)
    property color checkedHoverColor: FluTheme.dark ? Qt.darker(checkedColor,1.15) : Qt.lighter(checkedColor,1.15)
    property color checkedPreesedColor: FluTheme.dark ? Qt.darker(checkedColor,1.3) : Qt.lighter(checkedColor,1.3)
    property color checkedDisableColor: FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
    property color disableColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(253/255,253/255,253/255,1)
    property real size: 18
    property alias textColor: btn_text.textColor
    property bool textRight: true
    property real textSpacing: 6
    property bool enableAnimation: FluTheme.enableAnimation
    property var clickListener : function(){
        checked = !checked
    }
    property bool indeterminate : false
    id:control
    enabled: !disabled
    onClicked: clickListener()
    background: Item{
        FluFocusRectangle{
            radius: 4
            visible: control.activeFocus
        }
    }
    horizontalPadding:0
    verticalPadding: 0
    padding: 0
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    focusPolicy:Qt.TabFocus
    contentItem: RowLayout{
        spacing: control.textSpacing
        layoutDirection:control.textRight ? Qt.LeftToRight : Qt.RightToLeft
        Rectangle{
            width: control.size
            height: control.size
            radius: 4
            border.color: {
                if(!enabled){
                    return borderDisableColor
                }
                if(checked){
                    return bordercheckedColor
                }
                if(pressed){
                    return borderPressedColor
                }
                if(hovered){
                    return borderHoverColor
                }
                return borderNormalColor
            }
            border.width: 1
            color: {
                if(checked){
                    if(!enabled){
                        return checkedDisableColor
                    }
                    if(pressed){
                        return checkedPreesedColor
                    }
                    if(hovered){
                        return checkedHoverColor
                    }
                    return checkedColor
                }
                if(!enabled){
                    return disableColor
                }
                if(hovered){
                    return hoverColor
                }
                return normalColor
            }
            Behavior on color {
                enabled: control.enableAnimation
                ColorAnimation{
                    duration: 83
                }
            }

            FluIcon {
                anchors.centerIn: parent
                iconSource: FluentIcons.CheckboxIndeterminate
                iconSize: 14
                visible: indeterminate
                iconColor: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                Behavior on visible {
                    enabled: control.enableAnimation
                    NumberAnimation{
                        duration: 83
                    }
                }
            }

            FluIcon {
                anchors.centerIn: parent
                iconSource: FluentIcons.AcceptMedium
                iconSize: 14
                visible: checked && !indeterminate
                iconColor: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                Behavior on visible {
                    enabled: control.enableAnimation
                    NumberAnimation{
                        duration: 83
                    }
                }
            }
        }
        FluText{
            id:btn_text
            text: control.text
            Layout.alignment: Qt.AlignVCenter
            visible: text !== ""
        }
    }
}
