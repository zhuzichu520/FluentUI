import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Menu")

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
                showError(qsTr("Search"))
            }
        }
        Action {
            text: qsTr("Disable")
            enabled:false
            onTriggered: {
                showError(qsTr("Disable"))
            }
        }
        FluMenuSeparator { }
        Action { text: qsTr("Check");checkable: true;checked: true}
        FluMenu{
            title: qsTr("Save As...")
            Action { text: qsTr("Doc") }
            Action { text: qsTr("PDF") }
        }
    }


    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Column{
            id: layout_column
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }

            FluText{
                text: qsTr("Menu")
            }

            FluButton{
                text: qsTr("Show Menu Popup")
                Layout.topMargin: 20
                onClicked:{
                    menu.popup()
                }
            }


        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
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
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }

            FluText{
                text: qsTr("MenuBar")
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
                        title: qsTr("Save As...")
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
        Layout.topMargin: -6
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
