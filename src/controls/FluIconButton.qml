import QtQuick 2.15
import FluentUI 1.0

Rectangle {

    id:button
    width: 30
    height: 30

    property int iconSize: 20
    property int icon
    property alias text: tool_tip.text
    signal clicked
    property bool disabled: false
    property bool hovered: button_mouse.containsMouse

    property color hoverColor: FluTheme.isDark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(244/255,244/255,244/255,1)
    property color normalColor: FluTheme.isDark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(1,1,1,1)
    property color disableColor: FluTheme.isDark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(1,1,1,1)

    property color textColor: {
        if(FluTheme.isDark){
            if(disabled){
                return Qt.rgba(130/255,130/255,130/255,1)
            }
            return Qt.rgba(1,1,1,1)
        }else{
            if(disabled){
                return Qt.rgba(161/255,161/255,161/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }
    }
    radius: 4

    color: {
        if(disabled){
            return disableColor
        }
        return (hovered || button_mouse.containsMouse) ? hoverColor : normalColor
    }

    Text {
        id:text_icon
        font.family: "fontawesome"
        font.pixelSize: iconSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: parent
        color:button.textColor
        text: (String.fromCharCode(icon).toString(16));
    }

    MouseArea{
        id:button_mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: !disabled
        onClicked: {
            button.clicked()
        }
    }

    FluTooltip{
        id:tool_tip
        visible: {
            if(button.text === ""){
                return false
            }
            return (hovered || button_mouse.containsMouse)
        }
        delay: 1000
    }

}
