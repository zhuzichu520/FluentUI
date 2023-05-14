import QtQuick
import Qt5Compat.GraphicalEffects
import FluentUI

Item {
    id: control

    property alias color: rect.color
    property alias acrylicOpacity: rect.opacity
    property int radius: 50
    property var sourceItem: control.parent

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "white"
        opacity: 0.1
    }

    ShaderEffectSource {
        id: effect_source
        anchors.fill: parent
        sourceItem: control.sourceItem
        sourceRect: Qt.rect(control.x, control.y, control.width, control.height)
    }

    FastBlur {
        radius: control.radius
        anchors.fill: effect_source
        source: effect_source
    }
}
