import QtQuick 2.12
import QtGraphicalEffects 1.0
import FluentUI 1.0

Item {
    id: control
    property alias color: rect.color
    property alias acrylicOpacity: rect.opacity
    property alias radius:bg.radius
    property alias blurRadius: blur.radius
    property int rectX: control.x
    property int rectY: control.y
    property var sourceItem: control.parent
    FluRectangle{
        id:bg
        anchors.fill: parent
        radius: [8,8,8,8]
        ShaderEffectSource {
            id: effect_source
            anchors.fill: parent
            sourceItem: control.sourceItem
            sourceRect: Qt.rect(rectX, rectY, control.width, control.height)
            Rectangle {
                id: rect
                anchors.fill: parent
                color: "white"
                opacity: 0.5
            }
        }
        FastBlur {
            id:blur
            radius: 50
            anchors.fill: effect_source
            source: effect_source
        }
    }
}
