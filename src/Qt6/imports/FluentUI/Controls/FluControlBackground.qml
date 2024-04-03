import QtQuick
import QtQuick.Controls
import FluentUI

Item{
    id:control
    property int radius: 4
    property bool shadow: true
    property alias border: d.border
    property alias bottomMargin: rect_back.anchors.bottomMargin
    property alias topMargin: rect_back.anchors.topMargin
    property alias leftMargin: rect_back.anchors.leftMargin
    property alias rightMargin: rect_back.anchors.rightMargin
    property color color: FluTheme.dark ? Qt.rgba(42/255,42/255,42/255,1) : Qt.rgba(254/255,254/255,254/255,1)
    property alias gradient : rect_border.gradient
    Rectangle{
        id:d
        property color startColor: Qt.lighter(d.border.color,1.15)
        property color endColor: shadow ? control.border.color : startColor
        visible: false
        border.color: FluTheme.dark ? Qt.rgba(48/255,48/255,48/255,1) : Qt.rgba(206/255,206/255,206/255,1)
    }
    Rectangle{
        id:rect_border
        anchors.fill: parent
        radius: control.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: d.startColor }
            GradientStop { position: 0.8; color: d.startColor }
            GradientStop { position: 1.0; color: d.endColor}
        }
    }
    Rectangle{
        id:rect_back
        anchors.fill: parent
        anchors.margins: control.border.width
        radius: control.radius
        color: control.color
    }
}
