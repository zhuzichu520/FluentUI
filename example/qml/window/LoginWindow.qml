import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluWindow {

    id: window
    title: qsTr("Login")
    width: 400
    height: 400
    fixSize: true
    modality: Qt.ApplicationModal
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
            id: textbox_uesrname
            items:[{title:"Admin"},{title:"User"}]
            placeholderText: qsTr("Please enter the account")
            Layout.preferredWidth: 260
            Layout.alignment: Qt.AlignHCenter
        }

        FluTextBox{
            id: textbox_password
            Layout.topMargin: 20
            Layout.preferredWidth: 260
            placeholderText: qsTr("Please enter your password")
            echoMode:TextInput.Password
            Layout.alignment: Qt.AlignHCenter
        }

        FluFilledButton{
            text: qsTr("Login")
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            onClicked:{
                if(textbox_password.text === ""){
                    showError(qsTr("Please feel free to enter a password"))
                    return
                }
                setResult({password:textbox_password.text})
                window.close()
            }
        }
    }
}
