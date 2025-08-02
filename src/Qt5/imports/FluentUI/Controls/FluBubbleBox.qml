import QtQuick 2.15
import QtQuick.Shapes 1.15
import FluentUI 1.0

Rectangle {
    id: control
    // target properties
    property Item attachTarget: null
    property string attachDirection: "top" // top, right, bottom, left
    property real attachMargin: 5
    property real targetAlignRatio: 0.5 // offset ratio to the target width or height
    property var targetX: function () {
        return attachTarget ? attachTarget.x : 0
    }
    property var targetY: function () {
        return attachTarget ? attachTarget.y : 0
    }
    // triangle properties
    property alias triangleItem: triangle
    property alias triangleWidth: triangle.width
    property alias triangleHeight: triangle.height
    property real triangleOffsetRatio: 0.5 // offset ratio to the triangle width or height
    readonly property string triangleDirection: {
        switch (attachDirection) {
        case "top":
            return "bottom"
        case "right":
            return "left"
        case "bottom":
            return "top"
        case "left":
            return "right"
        default:
            return "top"
        }
    }

    implicitWidth: 100
    implicitHeight: 50
    radius: 4
    color: FluTheme.dark ? Qt.rgba(
                               32 / 255, 32 / 255, 32 / 255,
                               1) : Qt.rgba(243 / 255, 243 / 255, 243 / 255, 1)

    x: {
        if (!attachTarget) {
            return 0
        }
        switch (attachDirection) {
        case "top":
        case "bottom":
            const baseX = targetX() + attachTarget.width * targetAlignRatio
            return baseX - control.width / 2
        case "left":
            return targetX() - control.width - triangle.width - attachMargin
        case "right":
            return targetX(
                        ) + attachTarget.width + triangle.width + attachMargin
        default:
            return 0
        }
    }

    y: {
        if (!attachTarget) {
            return 0
        }
        switch (attachDirection) {
        case "left":
        case "right":
            const baseY = targetY() + attachTarget.height * targetAlignRatio
            return baseY - control.height / 2
        case "top":
            return targetY() - control.height - triangle.height - attachMargin
        case "bottom":
            return targetY(
                        ) + attachTarget.height + triangle.height + attachMargin
        default:
            return 0
        }
    }

    QtObject {
        id: d
        readonly property real clampedRatio: {

            const isHorizontal = triangleDirection === "top"
                               || triangleDirection === "bottom"

            let clamped = triangleOffsetRatio
            const boxSize = isHorizontal ? control.width : control.height
            const triangleSize = isHorizontal ? triangle.width : triangle.height
            const minRatio = (triangleSize / 2 + control.radius) / boxSize
            const maxRatio = 1 - minRatio
            clamped = Math.max(minRatio, Math.min(maxRatio, clamped))

            if (attachTarget) {
                const targetSize = isHorizontal ? attachTarget.width : control.attachTarget.height
                const bubblePos = isHorizontal ? control.x - targetX(
                                                     ) : control.y - targetY()
                const targetRelativePos = targetAlignRatio * targetSize
                const trianglePos = clamped * boxSize - triangleSize / 2
                const minTrianglePos = -bubblePos - triangleSize / 2
                const maxTrianglePos = targetSize - bubblePos - triangleSize / 2
                const minTargetRatio = (minTrianglePos + triangleSize / 2) / boxSize
                const maxTargetRatio = (maxTrianglePos + triangleSize / 2) / boxSize
                clamped = Math.max(minTargetRatio,
                                   Math.min(maxTargetRatio, clamped))
            }

            return clamped
        }
    }

    Shape {
        id: triangle
        width: 30
        height: 20

        x: {
            switch (triangleDirection) {
            case "top":
            case "bottom":
                return control.width * d.clampedRatio - triangle.width / 2
            case "left":
                return -triangle.width
            case "right":
                return control.width
            default:
                return 0
            }
        }

        y: {
            switch (triangleDirection) {
            case "left":
            case "right":
                return control.height * d.clampedRatio - triangle.height / 2
            case "top":
                return -triangle.height
            case "bottom":
                return control.height
            default:
                return 0
            }
        }

        antialiasing: true
        layer.enabled: true
        layer.samples: 8
        smooth: true
        ShapePath {
            fillColor: control.color
            strokeColor: control.color
            startX: {
                switch (triangleDirection) {
                case "left":
                    return triangle.width
                case "top":
                case "right":
                case "bottom":
                    return 0
                default:
                    return 0
                }
            }
            startY: {
                switch (triangleDirection) {
                case "top":
                    return triangle.height
                case "right":
                case "bottom":
                case "left":
                    return 0
                default:
                    return 0
                }
            }
            PathLine {
                x: {
                    switch (triangleDirection) {
                    case "top":
                    case "bottom":
                        return triangle.width / 2
                    case "right":
                        return triangle.width
                    case "left":
                        return 0
                    default:
                        return 0
                    }
                }
                y: {
                    switch (triangleDirection) {
                    case "bottom":
                        return triangle.height
                    case "right":
                    case "left":
                        return triangle.height / 2
                    case "top":
                        return 0
                    default:
                        return 0
                    }
                }
            }
            PathLine {
                x: {
                    switch (triangleDirection) {
                    case "top":
                    case "bottom":
                    case "left":
                        return triangle.width
                    case "right":
                        return 0
                    default:
                        return 0
                    }
                }
                y: {
                    switch (triangleDirection) {
                    case "top":
                    case "right":
                    case "left":
                        return triangle.height
                    case "bottom":
                        return 0
                    default:
                        return 0
                    }
                }
            }
        }
    }
}
