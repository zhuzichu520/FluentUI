import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "qrc:///example/qml/component"

CustomWindow {

    id:window
    title:"登录"
    width: 400
    height: 400
    fixSize: true

    onInitArgument:
        (argument)=>{
            textbox_uesrname.updateText(argument.username)
            textbox_password.focus =  true
        }

    ColumnLayout{
        anchors{
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        FluAutoSuggestBox{
            id:textbox_uesrname
            items:[{title:"Admin"},{title:"User"}]
            placeholderText: "请输入账号"
            Layout.preferredWidth: 260
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox{
            id:textbox_password
            Layout.topMargin: 20
            Layout.preferredWidth: 260
            placeholderText: "请输入密码"
            echoMode:TextInput.Password
            Layout.alignment: Qt.AlignHCenter
        }

        FluFilledButton{
            text:"登录"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            onClicked:{
                if(textbox_password.text === ""){
                    showError("请随便输入一个密码")
                    return
                }
                onResult({password:textbox_password.text})
                window.close()
            }
        }

    }



}
