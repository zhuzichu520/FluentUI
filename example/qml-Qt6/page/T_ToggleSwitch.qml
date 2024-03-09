import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("ToggleSwitch")

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
        Row{
            spacing: 30
            anchors.verticalCenter: parent.verticalCenter
            FluToggleSwitch{
                disabled: toggle_switch.checked
            }
            FluToggleSwitch{
                disabled: toggle_switch.checked
                text: qsTr("Right")
            }
            FluToggleSwitch{
                disabled: toggle_switch.checked
                text: qsTr("Left")
                textRight: false
            }
        }
        FluToggleSwitch{
            id: toggle_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("Disabled")
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluToggleSwitch{
    text:"Text"
}'
    }


}
