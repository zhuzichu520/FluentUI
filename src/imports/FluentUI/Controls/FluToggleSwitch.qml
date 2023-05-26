import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Button {
    property bool disabled: false
    property color disableColor: checked ? FluTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(159/255,159/255,159/255,1) :FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(240/255,240/255,240/255,1)
    property color checkColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color hoverColor: FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(240/255,240/255,240/255,1)
    property color normalColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(253/255,253/255,253/255,1)
    property color borderNormalColor: FluTheme.dark ? Qt.rgba(161/255,161/255,161/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color borderCheckColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color borderDisableColor: FluTheme.dark ? Qt.rgba(208/255,208/255,208/255,1) : Qt.rgba(93/255,93/255,93/255,1)
    property color dotNormalColor: FluTheme.dark ? Qt.rgba(208/255,208/255,208/255,1) : Qt.rgba(93/255,93/255,93/255,1)
    property color dotCheckColor: FluTheme.dark ? Qt.rgba(0/255,0/255,0/255,1) : Qt.rgba(255/255,255/255,255/255,1)
    property var clickListener : function(){
        checked = !checked
    }
    id: control
    height: 20
    enabled: !disabled
    implicitHeight: height
    focusPolicy:Qt.TabFocus
    Keys.onSpacePressed: control.visualFocus&&clicked()
    onClicked: clickListener()
    contentItem: Item{}
    background : RowLayout{
        spacing: 0
        Rectangle {
            id:control_backgound
            width: 40
            height: control.height
            radius: height / 2
            FluFocusRectangle{
                visible: control.visualFocus
                radius: 20
            }
            color: {
                if(disabled){
                    return disableColor
                }
                if(checked){
                    return checkColor
                }
                if(hovered){
                    return hoverColor
                }
                return normalColor
            }
            border.width: 1
            border.color: {
                if(disabled){
                    return borderDisableColor
                }
                if(checked){
                    return borderCheckColor
                }
                return borderNormalColor
            }
            Rectangle {
                width: pressed ? 28 : 20
                anchors{
                    left: checked ? undefined : parent.left
                    leftMargin: checked ? 20 : 0
                    right: checked ? parent.right : undefined
                    rightMargin: checked ? 0: 20
                }
                height: 20
                radius: 10
                scale: hovered&!disabled ? 7/10 : 6/10
                anchors.verticalCenter: parent.verticalCenter
                color: {
                    if(checked){
                        return dotCheckColor
                    }
                    return dotNormalColor
                }
                Behavior on anchors.leftMargin  {
                    NumberAnimation {
                        duration: 167
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [ 1, 0, 0, 0 ]
                    }
                }
                Behavior on anchors.rightMargin  {
                    NumberAnimation {
                        duration: 167
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [ 1, 0, 0, 0 ]
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: 167
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [ 1, 0, 0, 0 ]
                    }
                }
                Behavior on scale {
                    NumberAnimation {
                        duration: 167
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [ 1, 0, 0, 0 ]
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
