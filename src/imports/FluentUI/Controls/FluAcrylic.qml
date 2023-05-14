import QtQuick
import Qt5Compat.GraphicalEffects
import FluentUI

Item {
    id: control

    property alias color: rect.color
    property alias acrylicOpacity: rect.opacity
    property var sourceItem: control.parent

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "white"
        opacity: 0.05
    }

    ShaderEffectSource {
        id: effect_source
        anchors.fill: parent
        sourceItem: control.sourceItem
        sourceRect: Qt.rect(control.x, control.y, control.width, control.height)
    }

    FastBlur {
        radius: 20
        anchors.fill: effect_source
        source: effect_source
    }
}
