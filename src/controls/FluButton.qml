import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: button

    property string text: "Standard Button"
    property int startPadding : 15
    property int endPadding : 15
    property int topPadding: 5
    property int bottomPadding: 5
    property bool disabled: false
    property color primaryColor : "#0064B0"
    signal clicked
    radius: 4

    color:{
        if(FluTheme.isDark){
            if(disabled){
                return Qt.rgba(59/255,59/255,59/255,1)
            }
            return  button_mouse.containsMouse ? "#444444" : "#3e3e3e"
        }else{
            if(disabled){
                return Qt.rgba(252/255,252/255,252/255,1)
            }
            return  button_mouse.containsMouse ? "#FBFBFB" : "#FFFFFF"
        }
    }
    width: button_text.implicitWidth
    height: button_text.implicitHeight

    border.color: FluTheme.isDark ? "#505050" : "#DFDFDF"
    border.width: 1


    FluText {
        id: button_text
        text: button.text
        leftPadding: button.startPadding
        rightPadding: button.endPadding
        topPadding: button.topPadding
        bottomPadding: button.bottomPadding
        anchors.centerIn: parent
        color: {
            if(FluTheme.isDark){
                if(disabled){
                    return Qt.rgba(131/255,131/255,131/255,1)
                }
                return Qt.rgba(1,1,1,1)
            }else{
                if(disabled){
                    return Qt.rgba(160/255,160/255,160/255,1)
                }
                return Qt.rgba(0,0,0,1)
            }
        }
    }

    MouseArea {
        id:button_mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: !disabled
        onClicked: {
            button.clicked()
        }
    }
}
