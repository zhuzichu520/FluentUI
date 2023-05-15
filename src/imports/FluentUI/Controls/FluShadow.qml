import QtQuick
import QtQuick.Controls
import FluentUI

Item {

    property color color: FluTheme.dark ? "#FFFFFF" : "#999999"
    property int radius: 4
    id:control
    anchors.fill: parent
    anchors.margins: -4
    Rectangle{
        width: control.width
        height: control.height
        anchors.centerIn: parent
        color: "#00000000"
        opacity: 0.02
        border.width: 1
        radius: control.radius
        border.color: control.color
    }

    Rectangle{
        width: control.width - 2
        height: control.height - 2
        anchors.centerIn: parent
        color: "#00000000"
        opacity: 0.04
        border.width: 1
        radius: control.radius
        border.color: control.color
    }
    Rectangle{
        width: control.width - 4
        height: control.height - 4
        anchors.centerIn: parent
        color: "#00000000"
        opacity: 0.06
        border.width: 1
        radius: control.radius
        border.color: control.color
    }

    Rectangle{
        width: control.width - 6
        height: control.height - 6
        anchors.centerIn: parent
        color: "#00000000"
        opacity: 0.08
        border.width: 1
        radius: control.radius
        border.color: control.color
    }

    Rectangle{
        width: control.width - 8
        height: control.height - 8
        anchors.centerIn: parent
        opacity: 0.1
        radius: control.radius
        color: "#00000000"
        border.width: 1
        border.color: control.color
    }

}
