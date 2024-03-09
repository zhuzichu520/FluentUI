import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("StatusLayout")

    FluArea{
        id:layout_actions
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 50
        paddings: 10
        RowLayout{
            spacing: 14
            FluDropDownButton{
                id:btn_status_mode
                Layout.preferredWidth: 140
                text:"Loading"
                FluMenuItem{
                    text:"Loading"
                    onClicked: {
                        btn_status_mode.text = text
                        status_view.statusMode = FluStatusLayoutType.Loading
                    }
                }
                FluMenuItem{
                    text:"Empty"
                    onClicked: {
                        btn_status_mode.text = text
                        status_view.statusMode = FluStatusLayoutType.Empty
                    }
                }
                FluMenuItem{
                    text:"Error"
                    onClicked: {
                        btn_status_mode.text = text
                        status_view.statusMode = FluStatusLayoutType.Error
                    }
                }
                FluMenuItem{
                    text:"Success"
                    onClicked: {
                        btn_status_mode.text = text
                        status_view.statusMode = FluStatusLayoutType.Success
                    }
                }
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 10
        height: 380
        paddings: 10
        FluStatusLayout{
            id:status_view
            anchors.fill: parent
            loadingText: qsTr("Loading...")
            emptyText: qsTr("Empty")
            errorText: qsTr("The page went wrong...")
            errorButtonText: qsTr("Reload")
            onErrorClicked:{
                showError("Click Reload")
            }
            Rectangle {
                anchors.fill: parent
                color:FluTheme.primaryColor
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluStatusLayout{
    anchors.fill: parent
    statusMode: FluStatusLayoutType.Loading
    Rectangle{
        anchors.fill: parent
        color:FluTheme.primaryColor
    }
}'
    }

}
