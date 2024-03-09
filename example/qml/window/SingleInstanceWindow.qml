import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
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
        wrapMode: Text.WrapAnywhere
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
