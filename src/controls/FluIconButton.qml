import QtQuick 2.15

Rectangle {

    id:button
    width: 30
    height: 30

    property int iconSize: 20
    property int icon
    property color iconColor: "#000000"
    signal clicked

    radius: 4

    color: {
        if(FluApp.isDark){
            return button_mouse.containsMouse ? "#000000" : "#00000000"
        }else{
            return button_mouse.containsMouse ? "#F4F4F4" : "#00000000"
        }
    }

    Text {
        id:text_icon
        font.family: "fontawesome"
        font.pixelSize: iconSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: parent
        color: iconColor
        text: (String.fromCharCode(icon).toString(16));
    }

    MouseArea{
        id:button_mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            button.clicked()
        }
    }

}
