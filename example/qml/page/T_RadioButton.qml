import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"RadioButton"

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
        Row{
            spacing: 30
            anchors.verticalCenter: parent.verticalCenter
            FluRadioButton{
                disabled: radio_button_switch.checked
            }
            FluRadioButton{
                disabled: radio_button_switch.checked
                text:"Right"
            }
            FluRadioButton{
                disabled: radio_button_switch.checked
                text:"Left"
                textRight: false
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
    text:"Text"
}'
    }

}
