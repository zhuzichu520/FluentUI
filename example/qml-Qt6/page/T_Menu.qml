import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title:"Menu"

    FluMenu {
        id:menu
        title: qsTr("File")
        Action { text: qsTr("New...")}
        Action { text: qsTr("Open...") }
        Action { text: qsTr("Save") }
        FluMenuSeparator { }
        FluMenuItem{
            text: qsTr("Quit")
            onTriggered: {
                showError("Quit")
            }
        }
        FluMenuItem{
            text: qsTr("Search")
            iconSource: FluentIcons.Zoom
            iconSpacing: 3
            onTriggered: {
                showError("Search")
            }
        }
        Action {
            text: qsTr("Disable")
            enabled:false
            onTriggered: {
                showError("Disable")
            }
        }
        FluMenuSeparator { }
        Action { text: qsTr("Check");checkable: true;checked: true}
        FluMenu{
            title: "Save As..."
            Action { text: qsTr("Doc") }
            Action { text: qsTr("PDF") }
        }
    }


    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20
        Column{
            id:layout_column
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }

            FluText{
                text:"Menu"
            }

            FluButton{
                text:"Show Menu Popup"
                Layout.topMargin: 20
                onClicked:{
                    menu.popup()
                }
            }


        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluMenu{
    id:menu
    FluMenuItem:{
        text:"删除"
        onClicked: {
            showError("删除")
        }
    }
    FluMenuItem:{
        text:"修改"
        onClicked: {
            showInfo("修改")
        }
    }
}
menu.popup()
'
    }


    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }

            FluText{
                text:"MenuBar"
            }

            FluMenuBar {
                id:menu_bar
                FluMenu {
                    title: qsTr("File")
                    Action { text: qsTr("New...") }
                    Action { text: qsTr("Open...") }
                    Action { text: qsTr("Save") }
                    FluMenuSeparator { }
                    Action { text: qsTr("Quit") }
                    Action {
                        text: qsTr("Disable")
                        enabled:false
                    }
                    FluMenu{
                        title: "Save As..."
                        Action { text: qsTr("Doc") }
                        Action { text: qsTr("PDF") }
                    }
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

        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluMenuBar{
    id:menu
    FluMenu:{
        title:"File"
        Action { text: qsTr("New...") }
    }
    FluMenu:{
        title:"Edit"
        Action { text: qsTr("Cut") }
        Action { text: qsTr("Copy") }
        Action { text: qsTr("Paste") }
    }
}
menu.popup()
'
    }




}
