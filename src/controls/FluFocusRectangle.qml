import QtQuick 2.15
import FluentUI 1.0

Item {

    property int radius: 4

    id:root
    anchors.fill: parent
    anchors.margins: -3

    Rectangle{
        width: root.width
        height: root.height
        anchors.centerIn: parent
        color: "#00000000"
        border.width: 3
        radius: root.radius
        border.color: FluTheme.isDark ? Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
        z: 65535
    }

}
