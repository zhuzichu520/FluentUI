import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import Qt.labs.platform
import "../component"

FluWindowDialog {

    id:window
    title:qsTr("FluentUI Initalizr")
    width: 600
    height: 400

    contentDelegate:Component{
        Item{
            Connections{
                target: InitalizrHelper
                function onError(message){
                    showError(message)
                }
                function onSuccess(path){
                    FluTools.showFileInFolder(path+"/CMakeLists.txt")
                    window.close()
                }
            }

            FluText{
                id:text_title
                text:qsTr("FluentUI Initalizr")
                font: FluTextStyle.Title
                anchors{
                    left: parent.left
                    top: parent.top
                    leftMargin: 20
                    topMargin: 20
                }
            }

            Column{
                spacing: 14
                anchors{
                    left: parent.left
                    top: text_title.bottom
                    leftMargin: 20
                    topMargin: 20
                }
                FluTextBox{
                    id:text_box_name
                    width: 180
                    placeholderText: qsTr("Name")
                    focus: true
                }
                Row{
                    spacing: 8
                    FluTextBox{
                        id:text_box_path
                        width: 300
                        placeholderText: qsTr("Create In")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    FluButton{
                        text:qsTr("Browse")
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            folder_dialog.open()
                        }
                    }
                }
            }

            FolderDialog{
                id:folder_dialog
                onAccepted: {
                    text_box_path.text = FluTools.toLocalPath(currentFolder)
                }
            }

            Rectangle{
                id:layout_actions
                width: parent.width
                height: 60
                anchors.bottom: parent.bottom
                color: FluTheme.backgroundColor
                Row{
                    height: parent.height
                    spacing: 20
                    anchors{
                        right: parent.right
                        rightMargin: 20
                    }
                    FluButton{
                        text:qsTr("Cancel")
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            window.close()
                        }
                    }
                    FluFilledButton{
                        text:qsTr("Create")
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            InitalizrHelper.generate(text_box_name.text,text_box_path.text)
                        }
                    }
                }
            }
        }
    }

}
