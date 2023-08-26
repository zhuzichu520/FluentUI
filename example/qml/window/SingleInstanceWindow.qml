import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import "qrc:///example/qml/component"
import "../component"

CustomWindow {

    id:window
    title:"SingleInstance"
    width: 500
    height: 600
    fixSize: true
    launchMode: FluWindowType.SingleInstance

    FluTextBox{
        anchors{
            top:parent.top
            topMargin:60
            horizontalCenter: parent.horizontalCenter
        }
    }

    FluText{
        wrapMode: Text.WrapAnywhere
        anchors{
            left: parent.left
            right: parent.right
            leftMargin: 20
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
        text:"我是一个SingleInstance模式的窗口，如果我存在，我会销毁之前的窗口，并创建一个新窗口"
    }
}
