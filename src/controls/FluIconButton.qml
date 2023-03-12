import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Control {

    id:control
    width: 30
    height: 30

    property int iconSize: 20
    property int icon
    property alias text: tool_tip.text
    signal clicked
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

    focusPolicy:Qt.TabFocus
    Keys.onEnterPressed:(visualFocus&&handleClick())
    Keys.onReturnPressed:(visualFocus&&handleClick())

    MouseArea {
        anchors.fill: parent
        onClicked: handleClick()
    }

    function handleClick(){
        if(disabled){
            return
        }
        control.clicked()
    }

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
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
            color:control.textColor
            text: (String.fromCharCode(icon).toString(16));
        }

        FluTooltip{
            id:tool_tip
            visible: {
                if(control.text === ""){
                    return false
                }
                return hovered
            }
            delay: 1000
        }
    }




}
