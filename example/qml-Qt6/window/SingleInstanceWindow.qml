import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import "../component"

FluWindow {

    id: window
    title: qsTr("SingleInstance")
    width: 500
    height: 600
    fixSize: true
    launchMode: FluWindowType.SingleInstance

    FluTextBox{
        anchors{
            top:parent.top
            topMargin:60
            horizontalCenter: parent.horizontalCenter
        }
    }

    FluText{
        wrapMode: Text.WordWrap
        anchors{
            left: parent.left
            right: parent.right
            leftMargin: 20
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
        text: qsTr("I'm a SingleInstance window, and if I exist, I'll destroy the previous window and create a new one")
    }
}
