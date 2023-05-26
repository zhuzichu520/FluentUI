import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Button {
    property bool disabled: false
    property color borderNormalColor: checked ? FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark : FluTheme.dark ? Qt.rgba(161/255,161/255,161/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color borderDisableColor:  FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(198/255,198/255,198/255,1)
    property color normalColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(1,1,1,1)
    property color hoverColor: checked ? FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(1,1,1,1) : FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(222/255,222/255,222/255,1)
    property color disableColor: checked ? FluTheme.dark ? Qt.rgba(159/255,159/255,159/255,1) : Qt.rgba(159/255,159/255,159/255,1)  : FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(222/255,222/255,222/255,1)
    property var clickListener : function(){
        checked = !checked
    }
    id:control
    enabled: !disabled
    focusPolicy:Qt.TabFocus
    padding:0
    background: Item{
        FluFocusRectangle{
            visible: control.visualFocus
        }
    }
    font:FluTextStyle.Body
    Keys.onSpacePressed: control.visualFocus&&clicked()
    onClicked: clickListener()
    contentItem: RowLayout{
        Rectangle{
            id:rect_check
            width: 20
            height: 20
            radius: 10
            border.width: {
                if(checked&&disabled){
                    return 3
                }
                if(pressed){
                    if(checked){
                        return 5
                    }
                    return 1
                }
                if(hovered){
                    if(checked){
                        return 3
                    }
                    return 1
                }
                return checked ? 5 : 1
            }
            Behavior on border.width {
                NumberAnimation{
                    duration: 167
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: [ 0, 0, 0, 1 ]
                }
            }
            border.color: {
                if(disabled){
                    return borderDisableColor
                }
                return  borderNormalColor
            }
            color:{
                if(disabled){
                    return disableColor
                }
                if(hovered){
                    return hoverColor
                }
                return normalColor
            }
        }
        FluText{
            text: control.text
            Layout.alignment: Qt.AlignVCenter
            font: control.font
        }
    }
}
