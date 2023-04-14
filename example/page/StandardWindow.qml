import QtQuick 2.15
import QtQuick.Controls  2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluWindow {

    id:window

    width: 500
    height: 600
    minimumWidth: 500
    minimumHeight: 600
    maximumWidth: 500
    maximumHeight: 600
    launchMode: FluWindow.Standard

    title:"Standard"

    FluAppBar{
        id:appbar
        title:"Standard"
        width:parent.width
    }

    FluText{
        anchors.centerIn: parent
        text:"我是一个Standard模式的窗口，每次我都会创建一个新的窗口"
    }

}
