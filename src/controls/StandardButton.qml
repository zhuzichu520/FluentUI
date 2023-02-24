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
    radius: 4
    color: "#FFFFFF"

    width: childrenRect.width
    height: childrenRect.height

    border.color: "#eeeeee"
    border.width: 1

    Text {
        id: buttonText
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
        anchors.fill: parent
        onClicked: {
            console.log("Button clicked")
        }
    }
}
