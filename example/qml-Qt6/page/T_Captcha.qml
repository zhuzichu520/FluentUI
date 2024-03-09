import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("Captcha")

    FluCaptcha{
        id: captcha
        Layout.topMargin: 20
        ignoreCase:switch_case.checked
        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                captcha.refresh()
            }
        }
    }

    FluButton{
        text: qsTr("Refresh")
        Layout.topMargin: 20
        onClicked: {
            captcha.refresh()
        }
    }

    FluToggleSwitch{
        id: switch_case
        text: qsTr("Ignore Case")
        checked: true
        Layout.topMargin: 10
    }

    RowLayout{
        spacing: 10
        Layout.topMargin: 10
        FluTextBox{
            id:text_box
            placeholderText: qsTr("Please enter a verification code")
            Layout.preferredWidth: 240
        }
        FluButton{
            text:"verify"
            onClicked: {
                var success =  captcha.verify(text_box.text)
                if(success){
                    showSuccess(qsTr("The verification code is correct"))
                }else{
                    showError(qsTr("Error validation, please re-enter"))
                }
            }
        }
    }
}
