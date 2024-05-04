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
            FluRadioButton{
                disabled: radio_button_switch.checked
            }
            FluRadioButton{
                disabled: radio_button_switch.checked
                text: qsTr("Right")
            }
            FluRadioButton{
                disabled: radio_button_switch.checked
                text: qsTr("Left")
                textRight: false
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
        code:'FluRadioButton{
    text:"Text"
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        FluRadioButtons{
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            currentIndex: 1
            FluRadioButton{
                disabled: radio_button_switch2.checked
                text: qsTr("Radio Button_1")
            }
            FluRadioButton{
                disabled: radio_button_switch2.checked
                text: qsTr("Radio Button_2")
            }
            FluRadioButton{
                disabled: radio_button_switch2.checked
                text: qsTr("Radio Button_3")
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
        code:'FluRadioButtons{
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

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        padding: 10
        Layout.topMargin: 20
        FluRadioButtons{
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            orientation: Qt.Horizontal
            currentIndex: 1
            FluRadioButton{
                disabled: radio_button_switch3.checked
                text: qsTr("Radio Button_1")
            }
            FluRadioButton{
                disabled: radio_button_switch3.checked
                text: qsTr("Radio Button_2")
            }
            FluRadioButton{
                disabled: radio_button_switch3.checked
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
        code:'FluRadioButtons{
    spacing: 8
    orientation: Qt.Horizontal
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

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        FluRadioButtons{
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            currentIndex: 1
            FluCheckBox{
                disabled: radio_button_switch4.checked
                text: qsTr("Radio Button_1")
            }
            FluCheckBox{
                disabled: radio_button_switch4.checked
                text: qsTr("Radio Button_2")
            }
            FluCheckBox{
                disabled: radio_button_switch4.checked
                text: qsTr("Radio Button_3")
            }
        }
        FluToggleSwitch{
            id: radio_button_switch4
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
        code:'FluRadioButtons{
    spacing: 8
    FluCheckBox{
        text:"Radio Button_1"
    }
    FluCheckBox{
        text:"Radio Button_2"
    }
    FluCheckBox{
        text:"Radio Button_3"
    }
}'
    }

}
