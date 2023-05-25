import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
Button {

    property bool disabled: false
    property bool selected: false
    property color normalColor: {
        if(selected){
           return G.FluTheme.dark ? G.FluTheme.primaryColor.lighter : G.FluTheme.primaryColor.dark
        }else{
           return G.FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(254/255,254/255,254/255,1)
        }
    }
    property color hoverColor: {
        if(selected){
            return G.FluTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
        }else{
            return G.FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
        }
    }
    property color disableColor: {
        if(selected){
            return G.FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
        }else{
            return G.FluTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(252/255,252/255,252/255,1)
        }
    }

    property color pressedColor: G.FluTheme.dark ? Qt.darker(normalColor,1.2) : Qt.lighter(normalColor,1.2)

    id: control
    enabled: !disabled
    Keys.onSpacePressed: control.visualFocus&&clicked()
    focusPolicy:Qt.TabFocus
    horizontalPadding:12
    background: Rectangle{
        implicitWidth: 28
        implicitHeight: 28
        radius: 4
        border.color: G.FluTheme.dark ? "#505050" : "#DFDFDF"
        border.width: selected ? 0 : 1
        FluFocusRectangle{
            visible: control.visualFocus
            radius:8
        }
        color:{
            if(disabled){
                return disableColor
            }
            if(selected){
                if(pressed){
                    return pressedColor
                }
            }
            return hovered ? hoverColor :normalColor
        }
    }
    contentItem: FluText {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: {
            if(selected){
                if(G.FluTheme.dark){
                    if(disabled){
                        return Qt.rgba(173/255,173/255,173/255,1)
                    }
                    return Qt.rgba(0,0,0,1)
                }else{
                    return Qt.rgba(1,1,1,1)
                }
            }else{
                if(G.FluTheme.dark){
                    if(disabled){
                        return Qt.rgba(131/255,131/255,131/255,1)
                    }
                    if(!selected){
                        if(pressed){
                            return Qt.rgba(162/255,162/255,162/255,1)
                        }
                    }
                    return Qt.rgba(1,1,1,1)
                }else{
                    if(disabled){
                        return Qt.rgba(160/255,160/255,160/255,1)
                    }
                    if(!selected){
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
