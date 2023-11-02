import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"StatusView"

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
                        status_view.statusMode = FluStatusViewType.Loading
                    }
                }
                FluMenuItem{
                    text:"Empty"
                    onClicked: {
                        btn_status_mode.text = text
                        status_view.statusMode = FluStatusViewType.Empty
                    }
                }
                FluMenuItem{
                    text:"Error"
                    onClicked: {
                        btn_status_mode.text = text
                        status_view.statusMode = FluStatusViewType.Error
                    }
                }
                FluMenuItem{
                    text:"Success"
                    onClicked: {
                        btn_status_mode.text = text
                        status_view.statusMode = FluStatusViewType.Success
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
        FluStatusView{
            id:status_view
            anchors.fill: parent
            onErrorClicked:{
                showError("点击重新加载")
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
        code:'FluStatusView{
    anchors.fill: parent
    statusMode: FluStatusViewType.Loading
    Rectangle{
        anchors.fill: parent
        color:FluTheme.primaryColor
    }
}'
    }

}
