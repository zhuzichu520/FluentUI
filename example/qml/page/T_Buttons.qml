import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Buttons"

    FluText{
        Layout.topMargin: 20
        text:"支持Tab键切换焦点，空格键执行点击事件"
    }

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20

        FluTextButton{
            disabled:text_button_switch.checked
            text:"Text Button"
            onClicked: {
                showInfo("点击Text Button")
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id:text_button_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text:"Disabled"
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluTextButton{
    text:"Text Button"
    onClicked: {

    }
}'
    }

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20

        FluButton{
            disabled:button_switch.checked
            text:"Standard Button"
            onClicked: {
                showInfo("点击StandardButton")
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id:button_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text:"Disabled"
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluButton{
    text:"Standard Button"
    onClicked: {

    }
}'
    }

    FluArea{
        Layout.fillWidth: true
        height: 68
        Layout.topMargin: 20
        paddings: 10

        FluFilledButton{
            disabled:filled_button_switch.checked
            text:"Filled Button"
            onClicked: {
                showWarning("点击FilledButton"+height)
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id:filled_button_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text:"Disabled"
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluFilledButton{
    text:"Filled Button"
    onClicked: {

    }
}'
    }

    FluArea{
        Layout.fillWidth: true
        height: 68
        Layout.topMargin: 20
        paddings: 10

        FluToggleButton{
            disabled:toggle_button_switch.checked
            text:"Toggle Button"
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id:toggle_button_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text:"Disabled"
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluToggleButton{
    text:"Toggle Button"
    onClicked: {
        checked = !checked
    }
}'
    }


    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
        FluIconButton{
            iconSource:FluentIcons.ChromeCloseContrast
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
        FluToggleSwitch{
            id:icon_button_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text:"Disabled"
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluIconButton{
    iconSource:FluentIcons.ChromeCloseContrast
    onClicked: {

    }
}'
    }

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
        FluDropDownButton{
            disabled:drop_down_button_switch.checked
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
        FluToggleSwitch{
            id:drop_down_button_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text:"Disabled"
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluDropDownButton{
    text:"DropDownButton"
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
}'
    }

    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20
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
                    clickListener:function(){
                        repeater.selecIndex = index
                    }
                }
            }
        }
        FluToggleSwitch{
            id:radio_button_switch
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text:"Disabled"
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluRadioButton{
    checked:true
    text:"Text Button"
    onClicked: {

    }
}'
    }

}
