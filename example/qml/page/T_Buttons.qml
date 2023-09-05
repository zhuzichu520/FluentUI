import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"
import "../component"

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
            contentDescription: "文本按钮"
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

    Timer{
        id:timer_progress
        interval: 200
        onTriggered: {
            btn_progress.progress = (btn_progress.progress + 0.1).toFixed(1)
            if(btn_progress.progress==1){
                timer_progress.stop()
            }else{
                timer_progress.start()
            }
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: 68
        Layout.topMargin: 20
        paddings: 10

        FluProgressButton{
            id:btn_progress
            disabled:progress_button_switch.checked
            text:"Progress Button"
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            onClicked: {
                btn_progress.progress = 0
                timer_progress.restart()
            }
        }
        FluToggleSwitch{
            id:progress_button_switch
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
        code:'FluProgressButton{
    text:"Progress Button"
    onClicked: {

    }
}'
    }


    FluArea{
        Layout.fillWidth: true
        height: layout_icon_button.height + 30
        paddings: 10
        Layout.topMargin: 20
        Flow{
            id:layout_icon_button
            spacing: 10
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: icon_button_switch.left
            }
            FluIconButton{
                disabled:icon_button_switch.checked
                iconDelegate: Image{ sourceSize: Qt.size(40,40) ; width: 20; height: 20; source: "qrc:/example/res/image/ic_home_github.png" }
                onClicked:{
                    showSuccess("点击IconButton")
                }
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeCloseContrast
                disabled:icon_button_switch.checked
                iconSize: 15
                text:"IconOnly"
                display: Button.IconOnly
                onClicked:{
                    showSuccess("Button.IconOnly")
                }
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeCloseContrast
                disabled:icon_button_switch.checked
                iconSize: 15
                text:"TextOnly"
                display: Button.TextOnly
                onClicked:{
                    showSuccess("Button.TextOnly")
                }
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeCloseContrast
                disabled:icon_button_switch.checked
                iconSize: 15
                text:"TextBesideIcon"
                display: Button.TextBesideIcon
                onClicked:{
                    showSuccess("Button.TextBesideIcon")
                }
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeCloseContrast
                disabled:icon_button_switch.checked
                iconSize: 15
                text:"TextUnderIcon"
                display: Button.TextUnderIcon
                onClicked:{
                    showSuccess("Button.TextUnderIcon")
                }
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
            FluMenuItem{
                text:"Menu_1"
            }
            FluMenuItem{
                text:"Menu_2"
            }
            FluMenuItem{
                text:"Menu_3"
            }
            FluMenuItem{
                text:"Menu_4"
                onClicked: {

                }
            }
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
}'
    }

    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20
        FluRadioButtons{
            spacing: 8
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluRadioButton{
                disabled:radio_button_switch.checked
                text:"Radio Button_1"
            }
            FluRadioButton{
                disabled:radio_button_switch.checked
                text:"Radio Button_2"
            }
            FluRadioButton{
                disabled:radio_button_switch.checked
                text:"Radio Button_3"
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
