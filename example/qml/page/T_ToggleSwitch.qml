import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
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
