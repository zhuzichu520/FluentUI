import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FluentUI 1.0
import "../component"

FluWindow {

    id:window
    title:"Standard"
    width: 500
    height: 600
    launchMode: FluWindow.Standard

    FluText{
        anchors.centerIn: parent
        text:"我是一个Standard模式的窗口，每次我都会创建一个新的窗口"
    }

}
