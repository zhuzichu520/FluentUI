//@uri FluentUI
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle {
    id: button
    width: 100
    height: 40
    radius: 4
    color: Material.accent
    border.color: Material.accent

    Text {
        id: buttonText
        text: "Button"
        color: "white"
        font.pixelSize: 14
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Button clicked")
        }
    }
}
