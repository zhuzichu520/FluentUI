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
        if(FluTheme.isDark){
            if(disabled){
                return Qt.rgba(199/255,199/255,199/255,1)
            }
            return  button_mouse.containsMouse ? Qt.darker(FluTheme.primaryColor.lighter,1.1) : FluTheme.primaryColor.lighter
        }else{
            if(disabled){
                return Qt.rgba(199/255,199/255,199/255,1)
            }
            return  button_mouse.containsMouse ? Qt.lighter(FluTheme.primaryColor.dark,1.1): FluTheme.primaryColor.dark
        }
    }
    width: button_text.implicitWidth
    height: button_text.implicitHeight

    FluText {
        id: button_text
        text: button.text
        color: {
            if(FluTheme.isDark){
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
