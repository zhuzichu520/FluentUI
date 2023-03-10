import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluScrollablePage{
    title:"Buttons"

    spacing: 20

    FluArea{
        Layout.topMargin: 20
        width: parent.width
        height: 68
        paddings: 10

        FluButton{
            disabled:button_switch.checked
            onClicked: {
                showInfo("点击StandardButton")
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }

        Row{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluToggleSwitch{
                id:button_switch
                Layout.alignment: Qt.AlignRight
            }
            FluText{
                text:"Disabled"
            }
        }
    }

    FluArea{
        width: parent.width
        height: 68
        paddings: 10

        FluFilledButton{
            disabled:filled_button_switch.checked
            onClicked: {
              showWarning("点击FilledButton")
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }

        Row{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluToggleSwitch{
                id:filled_button_switch
                Layout.alignment: Qt.AlignRight
            }
            FluText{
                text:"Disabled"
            }
        }
    }


    FluArea{
        width: parent.width
        height: 68
        paddings: 10

        FluIconButton{
            icon:FluentIcons.ChromeCloseContrast
            disabled:icon_button_switch.checked
            iconSize: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            onClicked:{
                showSuccess("点击IconButton")
            }
        }

        Row{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluToggleSwitch{
                id:icon_button_switch
                Layout.alignment: Qt.AlignRight
            }
            FluText{
                text:"Disabled"
            }
        }
    }

    FluArea{
        width: parent.width
        height: 100
        paddings: 10

        ColumnLayout{
            spacing: 8
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            Repeater{
                id:repeater
                property int selecIndex : 0
                model: 3
                delegate:  FluRadioButton{
                    checked : repeater.selecIndex===index
                    disabled:radio_button_switch.checked
                    text:"Radio Button_"+index
                    onClicked:{
                        repeater.selecIndex = index
                    }
                }
            }
        }


        Row{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluToggleSwitch{
                id:radio_button_switch
                Layout.alignment: Qt.AlignRight
            }
            FluText{
                text:"Disabled"
            }
        }
    }


    FluArea{
        width: parent.width
        height: 68
        paddings: 10

        FluCheckBox{
            disabled:icon_button_check.checked
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }


        Row{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluToggleSwitch{
                id:icon_button_check
                Layout.alignment: Qt.AlignRight
            }
            FluText{
                text:"Disabled"
            }
        }
    }
}
