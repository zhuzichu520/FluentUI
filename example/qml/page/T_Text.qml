import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Text")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        padding: 10

        FluCopyableText{
            enabled: !toggle_switch.checked
            text: qsTr("This is a text that can be copied")
            anchors.verticalCenter: parent.verticalCenter
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
        Layout.topMargin: -6
        code:'FluCopyableText{
    text: qsTr("This is a text that can be copied")
}'
    }

}
