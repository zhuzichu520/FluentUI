import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Button {
    property string contentDescription: ""
    property bool disabled: false
    property color borderNormalColor: checked ? FluTheme.primaryColor : FluTheme.dark ? Qt.rgba(161/255,161/255,161/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color borderDisableColor:  FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(198/255,198/255,198/255,1)
    property color normalColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(1,1,1,1)
    property color hoverColor: checked ? FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(1,1,1,1) : FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(222/255,222/255,222/255,1)
    property color disableColor: checked ? FluTheme.dark ? Qt.rgba(159/255,159/255,159/255,1) : Qt.rgba(159/255,159/255,159/255,1)  : FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(222/255,222/255,222/255,1)
    property color textColor: {
        if(FluTheme.dark){
            if(!enabled){
                return Qt.rgba(130/255,130/255,130/255,1)
            }
            return Qt.rgba(1,1,1,1)
        }else{
            if(!enabled){
                return Qt.rgba(161/255,161/255,161/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }
    }
    property real size: 18
    property bool textRight: true
    property real textSpacing: 6
    property var clickListener : function(){
        checked = !checked
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    id:control
    enabled: !disabled
    horizontalPadding:2
    verticalPadding: 2
    background: Item{
        FluFocusRectangle{
            visible: control.activeFocus
        }
    }
    focusPolicy:Qt.TabFocus
    font:FluTextStyle.Body
    onClicked: clickListener()
    contentItem: RowLayout{
        spacing: control.textSpacing
        layoutDirection:control.textRight ? Qt.LeftToRight : Qt.RightToLeft
        Rectangle{
            id:rect_check
            width: control.size
            height: control.size
            radius: size/2
            border.width: {
                if(checked&&!enabled){
                    return 3
                }
                if(pressed){
                    if(checked){
                        return 4
                    }
                    return 1
                }
                if(hovered){
                    if(checked){
                        return 3
                    }
                    return 1
                }
                return checked ? 4 : 1
            }
            Behavior on border.width {
                enabled: FluTheme.animationEnabled
                NumberAnimation{
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
            border.color: {
                if(!enabled){
                    return borderDisableColor
                }
                return  borderNormalColor
            }
            color:{
                if(!enabled){
                    return disableColor
                }
                if(hovered){
                    return hoverColor
                }
                return normalColor
            }
        }
        FluText{
            id:btn_text
            text: control.text
            Layout.alignment: Qt.AlignVCenter
            font: control.font
            visible: text !== ""
            color: control.textColor
        }
    }
}
