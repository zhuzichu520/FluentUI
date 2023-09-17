import QtQuick 2.15
import QtQuick.Window 2.15
import FluentUI 1.0

Rectangle {
    property real spacing
    property alias separatorHeight:separator.height
    id:control
    color:Qt.rgba(0,0,0,0)
    height: spacing*2+separator.height
    Rectangle{
        id:separator
        clip: true
        color: FluTheme.dark ? Qt.rgba(80/255,80/255,80/255,1) : Qt.rgba(210/255,210/255,210/255,1)
        width:parent.width
        anchors.centerIn: parent
    }
}
