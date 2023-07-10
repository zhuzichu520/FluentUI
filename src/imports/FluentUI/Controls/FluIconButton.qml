import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Button {
    property int iconSize: 20
    property int iconSource
    property bool disabled: false
    property int radius:4
    property string contentDescription: ""
    property color hoverColor: FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
    property color pressedColor: FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
    property color normalColor: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
    property color disableColor: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
    property color color: {
        if(!enabled){
            return disableColor
        }
        if(pressed){
            return pressedColor
        }
        return hovered ? hoverColor : normalColor
    }
    property color iconColor: {
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
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    id:control
    width: 30
    focusPolicy:Qt.TabFocus
    height: 30
    implicitWidth: width
    implicitHeight: height
    padding: 0
    enabled: !disabled
    background: Rectangle{
        radius: control.radius
        color:control.color
        FluFocusRectangle{
            visible: control.activeFocus
        }
    }
    contentItem: Item{
        FluIcon {
            id:text_icon
            font.pixelSize: iconSize
            iconSize: control.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
            iconColor: control.iconColor
            iconSource: control.iconSource;
        }
        FluTooltip{
            id:tool_tip
            visible: {
                if(control.text === ""){
                    return false
                }
                return hovered
            }
            text:control.text
            delay: 1000
        }
    }
}
