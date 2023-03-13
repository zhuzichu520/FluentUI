import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

FluScrollablePage{

    title:"MultiWindow"

    FluArea{
        width: parent.width
        height: 68
        paddings: 10
        Layout.topMargin: 20

        Column{
            spacing: 5
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
        height: 68
        paddings: 10
        Layout.topMargin: 20

        Column{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text:"页面跳转，并携带参数"
            }
            FluButton{
                text:"点击跳转"
                onClicked: {
                    FluApp.navigate("/login",{username:"zhuzichu"})
                }
            }
        }
    }



}
