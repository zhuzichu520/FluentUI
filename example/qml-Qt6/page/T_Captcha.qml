import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Captcha"


    FluCaptcha{
        id:captcha
        Layout.topMargin: 20
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

    RowLayout{
        spacing: 10
        Layout.topMargin: 10
        FluTextBox{
            id:text_box
            placeholderText: "请输入验证码"
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
