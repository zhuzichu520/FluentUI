import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluScrollablePage{

    title:"MultiWindow"

    property string password: ""

    property var loginPageRegister: registerForPageResult("/login")

    Connections{
        target: loginPageRegister
        function onResult(data)
        {
            password = data.password
        }
    }

    FluArea{
        width: parent.width
        height: 100
        paddings: 10
        Layout.topMargin: 20

        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text:"页面跳转，不携带任何参数"
            }
            FluButton{
                text:"点击跳转"
                onClicked: {
                    FluApp.navigate("/about")
                }
            }
        }
    }

    FluArea{
        width: parent.width
        height: 130
        paddings: 10
        Layout.topMargin: 20

        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text:"页面跳转，并携带参数用户名：zhuzichu"
            }
            FluButton{
                text:"点击跳转到登录"
                onClicked: {
                    loginPageRegister.launch({username:"zhuzichu"})
                }
            }

            FluText{
                text:"登录窗口返回过来的密码->"+password
            }
        }
    }



}
