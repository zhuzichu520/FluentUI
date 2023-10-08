import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import "qrc:///example/qml/component"

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
        text:"我是一个Standard模式的窗口，每次我都会创建一个新的窗口"
    }

}
