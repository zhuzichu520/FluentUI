import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import "../component"

FluWindow {

    id:window
    title:"Standard"
    width: 500
    height: 600
    fixSize: true
    launchMode: FluWindowType.Standard

    FluMenuBar {
        FluMenu {
            title: qsTr("File")
            Action { text: qsTr("New...") }
            Action { text: qsTr("Open...") }
            Action { text: qsTr("Save") }
            Action { text: qsTr("Save As...") }
            FluMenuSeparator { }
            Action { text: qsTr("Quit") }
        }
        FluMenu {
            title: qsTr("Edit")
            Action { text: qsTr("Cut") }
            Action { text: qsTr("Copy") }
            Action { text: qsTr("Paste") }
        }
        FluMenu {
            title: qsTr("Help")
            Action { text: qsTr("About") }
        }
    }

    FluText{
        anchors.centerIn: parent
        text: qsTr("I'm a Standard mode window, and every time I create a new window")
    }

}
