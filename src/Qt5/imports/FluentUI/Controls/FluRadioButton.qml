import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Button {
    property string contentDescription: ""
    property bool disabled: false
    property color borderNormalColor: checked ? FluTheme.primaryColor : FluTheme.dark ? Qt.rgba(161/255,161/255,161/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color borderDisableColor:  FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(198/255,198/255,198/255,1)
    property color normalColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(1,1,1,1)
    property color hoverColor: checked ? FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(1,1,1,1) : FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(222/255,222/255,222/255,1)
    property color disableColor: checked ? FluTheme.dark ? Qt.rgba(159/255,159/255,159/255,1) : Qt.rgba(159/255,159/255,159/255,1)  : FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(222/255,222/255,222/255,1)
    property alias textColor: btn_text.textColor
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
    onCheckableChanged: {
        if(checkable){
            checkable = false
        }
    }
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
            visible: text !== ""
            font: control.font
        }
    }
}
