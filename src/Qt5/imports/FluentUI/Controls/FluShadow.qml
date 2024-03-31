import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {
    //高性能阴影！！！比DropShadow阴影性能高出数倍！！！
    property color color: FluTheme.dark ? "#AAAAAA" : "#999999"
    property int elevation: 6
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
