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
    launchMode: FluWindow.SingleTask

    title:"SingleTask"

    FluAppBar{
        id:appbar
        title:"SingleTask"
        width:parent.width
    }

    FluText{
        anchors.centerIn: parent
        text:"我是一个SingleTask模式的窗口，如果我存在，我就激活窗口"
    }

}
