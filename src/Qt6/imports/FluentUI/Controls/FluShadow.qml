import QtQuick
import QtQuick.Controls
import FluentUI

Item {
    //高性能阴影！！！比DropShadow阴影性能高出数倍！！！
    property color color: FluTheme.dark ? "#000000" : "#999999"
    property int elevation: 5
    property int radius: 4
    id:control
    anchors.fill: parent
    Repeater{
        model: elevation
        Rectangle{
            anchors.fill: parent
            color: "#00000000"
            opacity: 0.01 * (elevation-index+1)
            anchors.margins: -index
            radius: control.radius+index
            border.width: index
            border.color: control.color
        }
    }
}
