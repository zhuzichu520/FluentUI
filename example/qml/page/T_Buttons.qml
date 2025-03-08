import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Buttons")

    FluText{
        text: qsTr("Support the Tab key to switch focus, and the Space key to perform click events")
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        Layout.topMargin: 10
        padding: 10

        FluTextButton{
            disabled: text_button_switch.checked
            text: qsTr("Text Button")
            onClicked: {
                showInfo("点击Text Button")
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id: text_button_switch
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
        code:'FluTextButton{
    text:"Text Button"
    onClicked: {

    }
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        padding: 10
        Layout.topMargin: 20

        FluButton{
            disabled: button_switch.checked
            text: qsTr("Standard Button")
            onClicked: {
                showInfo(qsTr("Click StandardButton"))
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id: button_switch
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
        code:'FluButton{
    text:"Standard Button"
    onClicked: {

    }
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        Layout.topMargin: 20
        padding: 10

        FluFilledButton{
            disabled: filled_button_switch.checked
            text: qsTr("Filled Button")
            onClicked: {
                showWarning(qsTr("Click FilledButton"))
            }
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id: filled_button_switch
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
        code:'FluFilledButton{
    text:"Filled Button"
    onClicked: {

    }
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        Layout.topMargin: 20
        padding: 10

        FluToggleButton{
            disabled:toggle_button_switch.checked
            text: qsTr("Toggle Button")
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }
        FluToggleSwitch{
            id: toggle_button_switch
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
        code:'FluToggleButton{
    text:"Toggle Button"
    onClicked: {
        checked = !checked
    }
}'
    }

    Timer{
        id: timer_progress
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

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        Layout.topMargin: 20
        padding: 10

        FluProgressButton{
            id: btn_progress
            disabled: progress_button_switch.checked
            text: qsTr("Progress Button")
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
            id: progress_button_switch
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
        code:'FluProgressButton{
    text:"Progress Button"
    onClicked: {

    }
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        Layout.topMargin: 20
        padding: 10

        FluLoadingButton{
            id: btn_loading
            loading: loading_button_switch.checked
            text: loading_button_switch.checked ? qsTr("Loading") : qsTr("Loading Button")
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            onClicked: {

            }
        }
        FluToggleSwitch{
            id: loading_button_switch
            checked: true
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: loading_button_switch.checked ? qsTr("Loading") : qsTr("Normal")
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluLoadingButton{
    text:"Loading Button"
    onClicked: {

    }
}'
    }


    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: layout_icon_button.height + 30
        padding: 10
        Layout.topMargin: 20
        Flow{
            id: layout_icon_button
            spacing: 10
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: icon_button_switch.left
            }
            FluIconButton{
                disabled: icon_button_switch.checked
                iconDelegate: Image{ sourceSize: Qt.size(40,40) ; width: 20; height: 20; source: "qrc:/example/res/image/ic_home_github.png" }
                onClicked:{
                    showSuccess(qsTr("Click IconButton"))
                }
            }
            FluIconButton{
                iconSource: FluentIcons.ChromeCloseContrast
                disabled: icon_button_switch.checked
                iconSize: 15
                text: qsTr("IconOnly")
                display: Button.IconOnly
                onClicked:{
                    showSuccess(qsTr("Button.IconOnly"))
                }
            }
            FluIconButton{
                iconSource: FluentIcons.ChromeCloseContrast
                disabled: icon_button_switch.checked
                iconSize: 15
                text: qsTr("TextOnly")
                display: Button.TextOnly
                onClicked:{
                    showSuccess(qsTr("Button.TextOnly"))
                }
            }
            FluIconButton{
                iconSource: FluentIcons.ChromeCloseContrast
                disabled: icon_button_switch.checked
                iconSize: 15
                text: qsTr("TextBesideIcon")
                display: Button.TextBesideIcon
                onClicked:{
                    showSuccess(qsTr("Button.TextBesideIcon"))
                }
            }
            FluIconButton{
                iconSource: FluentIcons.ChromeCloseContrast
                disabled: icon_button_switch.checked
                iconSize: 15
                text: qsTr("TextUnderIcon")
                display: Button.TextUnderIcon
                onClicked:{
                    showSuccess(qsTr("Button.TextUnderIcon"))
                }
            }
        }
        FluToggleSwitch{
            id: icon_button_switch
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
        code:'FluIconButton{
    iconSource:FluentIcons.ChromeCloseContrast
    onClicked: {

    }
}'
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        padding: 10
        Layout.topMargin: 20
        FluDropDownButton{
            disabled: drop_down_button_switch.checked
            text: qsTr("DropDownButton")
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluMenuItem{
                text: qsTr("Menu_1")
            }
            FluMenuItem{
                text: qsTr("Menu_2")
            }
            FluMenuItem{
                text: qsTr("Menu_3")
            }
            FluMenuItem{
                text: qsTr("Menu_4")
                onClicked: {

                }
            }
        }
        FluToggleSwitch{
            id: drop_down_button_switch
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

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        FluRadioButtons{
            spacing: 8
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            disabled: radio_button_switch.checked
            FluRadioButton{
                text: qsTr("Radio Button_1")
            }
            FluRadioButton{
                text: qsTr("Radio Button_2")
            }
            FluRadioButton{
                text: qsTr("Radio Button_3")
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
    checked:true
    text:"Text Button"
    onClicked: {

    }
}'
    }

}
