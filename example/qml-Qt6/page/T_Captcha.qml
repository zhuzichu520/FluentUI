import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title:"Captcha"

    FluCaptcha{
        id:captcha
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
        text:"Refresh"
        Layout.topMargin: 20
        onClicked: {
            captcha.refresh()
        }
    }

    FluToggleSwitch{
        id:switch_case
        text:"Ignore Case"
        checked: true
        Layout.topMargin: 10
    }

    RowLayout{
        spacing: 10
        Layout.topMargin: 10
        FluTextBox{
            id:text_box
            placeholderText: "请输入验证码"
            Layout.preferredWidth: 240
        }
        FluButton{
            text:"verify"
            onClicked: {
                var success =  captcha.verify(text_box.text)
                if(success){
                    showSuccess("验证码正确")
                }else{
                    showError("错误验证，请重新输入")
                }
            }
        }
    }
}
