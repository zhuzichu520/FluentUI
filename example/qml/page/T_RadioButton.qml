import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("RadioButton")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        padding: 10
        Row{
            spacing: 30
            anchors.verticalCenter: parent.verticalCenter
            ButtonGroup {
                id: group1
            }
            FluRadioButton{
                disabled: radio_button_switch.checked
                autoExclusive: false
            }
            FluRadioButton{
                disabled: radio_button_switch.checked
                text: qsTr("Right")
                ButtonGroup.group: group1
            }
            FluRadioButton{
                disabled: radio_button_switch.checked
                text: qsTr("Left")
                textRight: false
                ButtonGroup.group: group1
            }
        }
        FluToggleSwitch{
            id: radio_button_switch
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
        code:'Row{
    spacing: 30
    ButtonGroup {
        id: group
    }
    FluRadioButton{
        autoExclusive: false
    }
    FluRadioButton{
        text: Right
        ButtonGroup.group: group
    }
    FluRadioButton{
        text: "Left"
        textRight: false
        ButtonGroup.group: group
    }
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        ColumnLayout{
            spacing: 8
            enabled: !radio_button_switch2.checked
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            ButtonGroup {
                id: group2
            }
            FluRadioButton{
                text: qsTr("Radio Button_1")
                ButtonGroup.group: group2
            }
            FluRadioButton{
                text: qsTr("Radio Button_2")
                checked: true
                ButtonGroup.group: group2
            }
            FluRadioButton{
                text: qsTr("Radio Button_3")
                ButtonGroup.group: group2
            }
        }
        FluToggleSwitch{
            id: radio_button_switch2
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
        code:'ColumnLayout{
    spacing: 8
    ButtonGroup{
        id: group
    }
    FluRadioButton{
        text:"Radio Button_1"
        ButtonGroup.group: group
    }
    FluRadioButton{
        text:"Radio Button_2"
        ButtonGroup.group: group
    }
    FluRadioButton{
        text:"Radio Button_3"
        ButtonGroup.group: group
    }
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        padding: 10
        Layout.topMargin: 20
        RowLayout{
            spacing: 8
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            enabled: !radio_button_switch3.checked
            FluRadioButton{
                text: qsTr("Radio Button_1")
            }
            FluRadioButton{
                text: qsTr("Radio Button_2")
                checked: true
            }
            FluRadioButton{
                text: qsTr("Radio Button_3")
            }
        }
        FluToggleSwitch{
            id: radio_button_switch3
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
        code:'RowLayout{
    spacing: 8
    FluRadioButton{
        text:"Radio Button_1"
    }
    FluRadioButton{
        text:"Radio Button_2"
    }
    FluRadioButton{
        text:"Radio Button_3"
    }
}'
    }
}
