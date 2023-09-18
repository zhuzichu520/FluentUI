import QtQuick
import QtQuick.Window
import FluentUI

Rectangle {
    property real spacing
    property alias separatorHeight:separator.height
    id:control
    color:Qt.rgba(0,0,0,0)
    height: spacing*2+separator.height
    FluRectangle{
        id:separator
        color: FluTheme.dark ? Qt.rgba(80/255,80/255,80/255,1) : Qt.rgba(210/255,210/255,210/255,1)
        width:parent.width
        anchors.centerIn: parent
    }
}
