import QtQuick
import Qt5Compat.GraphicalEffects
import FluentUI

FluItem {
    id: control
    property color tintColor: Qt.rgba(1,1,1,1)
    property real tintOpacity: 0.65
    property real luminosity: 0.01
    property real noiseOpacity : 0.066
    property alias target : effect_source.sourceItem
    property int blurRadius: 32
    property rect targetRect : Qt.rect(control.x, control.y, control.width, control.height)
    ShaderEffectSource {
        id: effect_source
        anchors.fill: parent
        visible: false
        sourceRect: control.targetRect
    }
    FastBlur {
        id:fast_blur
        anchors.fill: parent
        source: effect_source
        radius: control.blurRadius
    }
    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(255, 255, 255, luminosity)
    }
    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(tintColor.r, tintColor.g, tintColor.b, tintOpacity)
    }
    Image{
        anchors.fill: parent
        source: "../Image/noise.png"
        fillMode: Image.Tile
        opacity: control.noiseOpacity
    }
}
