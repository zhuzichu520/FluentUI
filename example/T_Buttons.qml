import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluScrollablePage{
    title:"Buttons"

    spacing: 20

    FluText{
        Layout.topMargin: 20
        text:"支持Tab键切换焦点，空格键执行点击事件"
    }

    FluArea{
        width: parent.width
        height: 68
        paddings: 10

        FluButton{
            disabled:button_switch.selected
            text:"Standard Button"
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
            disabled:filled_button_switch.selected
            text:"Filled Button"
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
            iconSource:FluentIcons.ChromeCloseContrast
            disabled:icon_button_switch.selected
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
        height: 68
        paddings: 10

        FluDropDownButton{
            disabled:drop_down_button_switch.selected
            text:"DropDownButton"
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            items:[
                FluMenuItem{
                    text:"Menu_1"
                },
                FluMenuItem{
                    text:"Menu_2"
                },
                FluMenuItem{
                    text:"Menu_3"
                },
                FluMenuItem{
                    text:"Menu_4"
                }
            ]
        }
        Row{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluToggleSwitch{
                id:drop_down_button_switch
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
                    selected : repeater.selecIndex===index
                    disabled:radio_button_switch.selected
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
            disabled:check_box_switch.selected
            text:"Check Box"
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
                id:check_box_switch
                Layout.alignment: Qt.AlignRight
            }
            FluText{
                text:"Disabled"
            }
        }
    }


}
