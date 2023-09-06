import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI

Button {
    property real progress
    property bool disabled: false
    property string contentDescription: ""
    QtObject{
        id:d
        property bool checked: rect_back.height == background.height
    }
    property color normalColor: {
        if(d.checked){
            return FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
        }else{
            return FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(254/255,254/255,254/255,1)
        }
    }
    property color hoverColor: {
        if(d.checked){
            return FluTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
        }else{
            return FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
        }
    }
    property color disableColor: {
        if(d.checked){
            return FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
        }else{
            return FluTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(252/255,252/255,252/255,1)
        }
    }
    property color pressedColor: FluTheme.dark ? Qt.darker(normalColor,1.2) : Qt.lighter(normalColor,1.2)
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    focusPolicy:Qt.TabFocus
    id: control
    enabled: !disabled
    horizontalPadding:12
    background: FluItem{
        implicitWidth: 28
        implicitHeight: 28
        radius: [4,4,4,4]
        Rectangle{
            anchors.fill: parent
            border.color: FluTheme.dark ? "#505050" : "#DFDFDF"
            border.width: d.checked ? 0 : 1
            radius: 4
            color:{
                if(!enabled){
                    return disableColor
                }
                if(d.checked){
                    if(pressed){
                        return pressedColor
                    }
                }
                return hovered ? hoverColor :normalColor
            }
        }
        Rectangle{
            id:rect_back
            width: parent.width  * control.progress
            height: control.progress === 1 ? background.height : 3
            visible: !d.checked
            color: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
            anchors.bottom: parent.bottom
            Behavior on height{
                enabled: control.progress === 1
                SequentialAnimation {
                    PauseAnimation {
                        duration: FluTheme.enableAnimation ? 167 : 0
                    }
                    NumberAnimation{
                        duration: FluTheme.enableAnimation ? 167 : 0
                        from: 3
                        to: background.height
                    }
                }
            }
            Behavior on width{
                NumberAnimation{
                    duration: 167
                }
            }
        }
        FluFocusRectangle{
            visible: control.activeFocus
            radius:4
        }
    }
    contentItem: FluText {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: {
            if(d.checked){
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
                    if(!d.checked){
                        if(pressed){
                            return Qt.rgba(162/255,162/255,162/255,1)
                        }
                    }
                    return Qt.rgba(1,1,1,1)
                }else{
                    if(!enabled){
                        return Qt.rgba(160/255,160/255,160/255,1)
                    }
                    if(!d.checked){
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
