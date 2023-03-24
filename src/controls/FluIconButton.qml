import QtQuick
import QtQuick.Controls
import FluentUI

Button {

    property int iconSize: 20
    property int iconSource
    property bool disabled: false
    property color hoverColor: FluTheme.isDark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(0,0,0,0.03)
    property color normalColor: FluTheme.isDark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
    property color disableColor: FluTheme.isDark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(0,0,0,0)
    property color color: {
        if(disabled){
            return disableColor
        }
        return hovered ? hoverColor : normalColor
    }
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

    id:control
    width: 30
    height: 30
    implicitWidth: width
    implicitHeight: height
    padding: 0
    enabled: !disabled
    focusPolicy:Qt.TabFocus
    Keys.onSpacePressed: control.visualFocus&&clicked()
    background: Rectangle{
        radius: 4
        color:control.color
        FluFocusRectangle{
            visible: control.visualFocus
        }
    }
    contentItem: Item{
        Text {
            id:text_icon
            font.family: "Segoe Fluent Icons"
            font.pixelSize: iconSize
            width: iconSize
            height: iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
            color:control.textColor
            text: (String.fromCharCode(iconSource).toString(16));
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
