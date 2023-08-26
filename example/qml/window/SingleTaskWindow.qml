import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import "qrc:///example/qml/component"
import "../component"

CustomWindow {

    id:window
    title:"SingleTask"
    width: 500
    height: 600
    fixSize: true
    launchMode: FluWindowType.SingleTask

    FluText{
        anchors.centerIn: parent
        text:"我是一个SingleTask模式的窗口，如果我存在，我就激活窗口"
    }

}
