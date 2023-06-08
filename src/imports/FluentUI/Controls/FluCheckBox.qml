import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Button {
    property bool disabled: false
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
    property var clickListener : function(){
        checked = !checked
    }
    id:control
    enabled: !disabled
    padding:0
    onClicked: clickListener()
    background: Item{
        FluFocusRectangle{
            visible: control.activeFocus
        }
    }
    contentItem: RowLayout{
        spacing: 4
        Rectangle{
            width: 20
            height: 20
            radius: 4
            border.color: {
                if(disabled){
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
                    if(disabled){
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
                if(disabled){
                    return disableColor
                }
                if(hovered){
                    return hoverColor
                }
                return normalColor
            }
            Behavior on color {
                ColorAnimation{
                    duration: 83
                }
            }
            FluIcon {
                anchors.centerIn: parent
                iconSource: FluentIcons.AcceptMedium
                iconSize: 15
                visible: checked
                iconColor: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                Behavior on visible {
                    NumberAnimation{
                        duration: 83
                    }
                }
            }
        }
        FluText{
            text: control.text
            Layout.leftMargin: 5
            visible: text !== ""
        }
    }
}
