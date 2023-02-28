import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.15

Item{
    id:root
    property var radius:[0,0,0,0]
    property color color : "#FFFFFF"
    property color borderColor:"transparent"
    property int borderWidth: 1
    default property alias contentItem: container.children

    Rectangle{
        id:container
        width: root.width
        height: root.height
        visible: false
        color:root.color

    }

    Shape {
        id: shape
        width: root.width
        height: root.height
        layer.enabled: true
        layer.samples: 4
        layer.smooth: true
        visible: false
        ShapePath {
            startX: 0
            startY: radius[0]
            fillColor: color
            strokeColor: borderColor
            strokeWidth: borderWidth
            PathQuad { x: radius[0]; y: 0; controlX: 0; controlY: 0 }
            PathLine { x: shape.width - radius[1]; y: 0 }
            PathQuad { x: shape.width; y: radius[1]; controlX: shape.width; controlY: 0 }
            PathLine { x: shape.width; y: shape.height - radius[2] }
            PathQuad { x: shape.width - radius[2]; y: shape.height; controlX: shape.width; controlY: shape.height }
            PathLine { x: radius[3]; y: shape.height }
            PathQuad { x: 0; y: shape.height - radius[3]; controlX: 0; controlY: shape.height }
            PathLine { x: 0; y: radius[0] }
        }
    }

    OpacityMask {
        anchors.fill: container
        source: container
        maskSource: shape
    }

}
