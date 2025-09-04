import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("CheckBox")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 72
        padding: 10

        FluText{
            text: qsTr("A 2-state CheckBox")
        }

        Row{
            spacing: 30
            anchors{
                top: parent.top
                topMargin: 30
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
                text: qsTr("Right")
            }
            FluCheckBox{
                disabled: check_box_switch_two.checked
                text: qsTr("Left")
                textRight: false
            }
        }
        FluToggleSwitch{
            id:check_box_switch_two
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
        code:'FluCheckBox{
    text:"Text"
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 72
        padding: 10
        Layout.topMargin: 20

        FluText{
            text: qsTr("A 3-state CheckBox")
        }

        Row{
            spacing: 30
            anchors{
                top: parent.top
                topMargin: 30
            }
            FluCheckBox{
                text: qsTr("Three State")
                disabled: check_box_switch_three.checked
                tristate: true
            }
        }
        FluToggleSwitch{
            id:  check_box_switch_three
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
        code:'FluCheckBox{
    text:"Text"
    tristate: true
}'
    }

    FluFrame{
        Layout.fillWidth: true
        padding: 10
        Layout.topMargin: 20

        ColumnLayout {
            FluText{
                text: qsTr("Using a 3-state CheckBox")
            }
            ButtonGroup {
                id: group
                exclusive: false
                checkState: check_box_all.checkState
            }
            FluCheckBox {
                id: check_box_all
                text: qsTr("Select all")
                checkState: group.checkState
            }
            Repeater {
                model: 3
                FluCheckBox {
                    Layout.leftMargin: 24
                    text: qsTr("Option %1").arg(index)
                    ButtonGroup.group: group
                }
            }
        }
    }
}
