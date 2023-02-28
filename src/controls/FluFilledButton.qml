import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Rectangle {
    id: button

    property string text: "Filled Button"
    property int startPadding : 15
    property int endPadding : 15
    property int topPadding: 8
    property int bottomPadding: 8
    property bool disabled: false

    signal clicked
    radius: 4
    color:{
        if(FluApp.isDark){
            if(disabled){
                return Qt.rgba(199/255,199/255,199/255,1)
            }
            return  button_mouse.containsMouse ? Qt.rgba(74/255,149/255,207/255,1) : Qt.rgba(76/255,160/255,224/255,1)
        }else{
            if(disabled){
                return Qt.rgba(199/255,199/255,199/255,1)
            }
            return  button_mouse.containsMouse ? Qt.rgba(25/255,117/255,187/255,1) : Qt.rgba(0/255,102/255,180/255,1)
        }
    }
    width: button_text.implicitWidth
    height: button_text.implicitHeight

    FluText {
        id: button_text
        text: button.text
        color: {
            if(FluApp.isDark){
                if(disabled){
                    return Qt.rgba(173/255,173/255,173/255,1)
                }
                return Qt.rgba(0,0,0,1)
            }else{
                return Qt.rgba(1,1,1,1)
            }
        }
        font.pixelSize: 14
        leftPadding: button.startPadding
        rightPadding: button.endPadding
        topPadding: button.topPadding
        bottomPadding: button.bottomPadding
        anchors.centerIn: parent
    }

    MouseArea {
        id:button_mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if(disabled)
                return
            button.clicked()
        }
    }
}
