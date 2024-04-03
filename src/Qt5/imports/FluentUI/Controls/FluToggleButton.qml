import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Button {
    property bool disabled: false
    property string contentDescription: ""
    property color normalColor: {
        if(checked){
            return FluTheme.primaryColor
        }else{
            return FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(254/255,254/255,254/255,1)
        }
    }
    property color hoverColor: {
        if(checked){
            return FluTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
        }else{
            return FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(246/255,246/255,246/255,1)
        }
    }
    property color disableColor: {
        if(checked){
            return FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
        }else{
            return FluTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(251/255,251/255,251/255,1)
        }
    }
    property var clickListener : function(){
        checked = !checked
    }
    property color pressedColor: FluTheme.dark ? Qt.darker(normalColor,1.2) : Qt.lighter(normalColor,1.2)
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    focusPolicy:Qt.TabFocus
    id: control
    enabled: !disabled
    verticalPadding: 0
    horizontalPadding:12
    onClicked: clickListener()
    background: FluControlBackground{
        implicitWidth: 30
        implicitHeight: 30
        radius: 4
        FluFocusRectangle{
            visible: control.activeFocus
            radius:4
        }
        color:{
            if(!enabled){
                return disableColor
            }
            if(checked){
                if(pressed){
                    return pressedColor
                }
            }
            return hovered ? hoverColor :normalColor
        }
        bottomMargin: {
            if(checked){
                return enabled ? 2 : 0
            }else{
                return 1
            }
        }
        border.width: {
            if(checked){
                return enabled ? 1 : 0
            }else{
                return 1
            }
        }
        shadow: {
            if(checked){
                return true
            }else{
                return enabled
            }
        }
        border.color: {
            if(checked){
                return enabled ? Qt.darker(control.normalColor,1.2) : disableColor
            }else{
                return FluTheme.dark ? Qt.rgba(48/255,48/255,48/255,1) : Qt.rgba(206/255,206/255,206/255,1)
            }
        }



    }
    contentItem: FluText {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: {
            if(checked){
                if(FluTheme.dark){
                    if(!enabled){
                        return Qt.rgba(173/255,173/255,173/255,1)
                    }
                    return Qt.rgba(0,0,0,1)
                }else{
                    return Qt.rgba(1,1,1,1)
                }
            }else{
                if(FluTheme.dark){
                    if(!enabled){
                        return Qt.rgba(131/255,131/255,131/255,1)
                    }
                    if(!checked){
                        if(pressed){
                            return Qt.rgba(162/255,162/255,162/255,1)
                        }
                    }
                    return Qt.rgba(1,1,1,1)
                }else{
                    if(!enabled){
                        return Qt.rgba(160/255,160/255,160/255,1)
                    }
                    if(!checked){
                        if(pressed){
                            return Qt.rgba(96/255,96/255,96/255,1)
                        }
                    }
                    return Qt.rgba(0,0,0,1)
                }
            }
        }
    }
}
