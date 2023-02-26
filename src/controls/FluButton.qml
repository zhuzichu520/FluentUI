import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle {
    id: button

    property int startPadding : 15
    property int endPadding : 15
    property int topPadding: 8
    property int bottomPadding: 8
    property bool disabled: false
    signal clicked
    radius: 4
    color: button_mouse.containsMouse ? "#eeeeee" : "#FFFFFF"
    width: button_text.implicitWidth
    height: button_text.implicitHeight
    border.color: "#cccccc"
    border.width: 1

    Text {
        id: button_text
        text: "Standard Button"
        color: "#000000"
        font.pixelSize: 13
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
            button.clicked()
        }
    }
}
