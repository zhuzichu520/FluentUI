import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

T.CheckBox {
    property bool disabled: false
    property string contentDescription: ""
    property color borderNormalColor: FluTheme.dark ? Qt.rgba(160 / 255, 160 / 255, 160 / 255, 1) : Qt.rgba(136 / 255, 136 / 255, 136 / 255, 1)
    property color bordercheckedColor: FluTheme.primaryColor
    property color borderHoverColor: FluTheme.dark ? Qt.rgba(167 / 255, 167 / 255, 167 / 255, 1) : Qt.rgba(135 / 255, 135 / 255, 135 / 255, 1)
    property color borderDisableColor: FluTheme.dark ? Qt.rgba(82 / 255, 82 / 255, 82 / 255, 1) : Qt.rgba(199 / 255, 199 / 255, 199 / 255, 1)
    property color borderPressedColor: FluTheme.dark ? Qt.rgba(90 / 255, 90 / 255, 90 / 255, 1) : Qt.rgba(191 / 255, 191 / 255, 191 / 255, 1)
    property color normalColor: FluTheme.dark ? Qt.rgba(45 / 255, 45 / 255, 45 / 255, 1) : Qt.rgba(247 / 255, 247 / 255, 247 / 255, 1)
    property color checkedColor: FluTheme.primaryColor
    property color hoverColor: FluTheme.dark ? Qt.rgba(72 / 255, 72 / 255, 72 / 255, 1) : Qt.rgba(236 / 255, 236 / 255, 236 / 255, 1)
    property color checkedHoverColor: FluTheme.dark ? Qt.darker(checkedColor, 1.15) : Qt.lighter(checkedColor, 1.15)
    property color checkedPreesedColor: FluTheme.dark ? Qt.darker(checkedColor, 1.3) : Qt.lighter(checkedColor, 1.3)
    property color checkedDisableColor: FluTheme.dark ? Qt.rgba(82 / 255, 82 / 255, 82 / 255, 1) : Qt.rgba(199 / 255, 199 / 255, 199 / 255, 1)
    property color disableColor: FluTheme.dark ? Qt.rgba(50 / 255, 50 / 255, 50 / 255, 1) : Qt.rgba(253 / 255, 253 / 255, 253 / 255, 1)
    property color textColor: {
        if (FluTheme.dark) {
            if (!enabled) {
                return Qt.rgba(130 / 255, 130 / 255, 130 / 255, 1)
            }
            return Qt.rgba(1, 1, 1, 1)
        } else {
            if (!enabled) {
                return Qt.rgba(161 / 255, 161 / 255, 161 / 255, 1)
            }
            return Qt.rgba(0, 0, 0, 1)
        }
    }
    property real size: 18
    property bool textRight: true
    property bool animationEnabled: FluTheme.animationEnabled
    property var clickListener: function () {}
    id: control
    enabled: !control.disabled
    implicitWidth: Math.max(implicitContentWidth,
                            implicitIndicatorWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(
                        implicitContentHeight,
                        implicitIndicatorHeight) + topPadding + bottomPadding
    spacing: 6
    focusPolicy: Qt.TabFocus
    font: FluTextStyle.Body
    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked()
    background: Item {
        FluFocusRectangle {
            radius: 4
            visible: control.activeFocus
        }
    }
    indicator: Rectangle {
        implicitWidth: control.size
        implicitHeight: control.size
        anchors.verticalCenter: parent.verticalCenter
        x: control.textRight ? control.leftPadding : (control.width - width - control.rightPadding)
        radius: 4
        border.color: {
            if (!enabled) {
                return borderDisableColor
            }
            if (checked) {
                return bordercheckedColor
            }
            if (pressed) {
                return borderPressedColor
            }
            if (hovered) {
                return borderHoverColor
            }
            return borderNormalColor
        }
        border.width: 1
        color: {
            if (checkState === Qt.Checked
                    || checkState === Qt.PartiallyChecked) {
                if (!enabled) {
                    return checkedDisableColor
                }
                if (pressed) {
                    return checkedPreesedColor
                }
                if (hovered) {
                    return checkedHoverColor
                }
                return checkedColor
            }
            if (!enabled) {
                return disableColor
            }
            if (hovered) {
                return hoverColor
            }
            return normalColor
        }
        Canvas {
            id: markCanvas
            property real strokeProgress: 0.0
            property color strokeColor: FluTheme.dark ? "#000000" : "#FFFFFF"
            anchors.centerIn: parent
            width: size - 6
            height: width
            visible: state !== "unchecked"
            state: {
                if (checkState === Qt.Checked) {
                    return "checked"
                } else if (checkState === Qt.PartiallyChecked) {
                    return "partially"
                }
                return "unchecked"
            }
            states: [
                State {
                    name: "checked"
                    PropertyChanges {
                        target: markCanvas
                        strokeProgress: 1.0
                    }
                },
                State {
                    name: "partially"
                    PropertyChanges {
                        target: markCanvas
                        strokeProgress: 1.0
                    }
                },
                State {
                    name: "unchecked"
                    PropertyChanges {
                        target: markCanvas
                        strokeProgress: 0.0
                    }
                }
            ]
            onStateChanged: {
                if (state !== "unchecked") {
                    requestPaint()
                }
            }
            onStrokeProgressChanged: requestPaint()
            onStrokeColorChanged: requestPaint()
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.save()
                ctx.strokeStyle = strokeColor
                ctx.lineWidth = 2.0
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                if (state === "checked") {
                    // draw Accept
                    const startX = width * 0.15, startY = height * 0.5
                    const midX = width * 0.4, midY = height * 0.75
                    const endX = width - startX, endY = height * 0.3
                    const line1Width = Math.sqrt(Math.pow(midX - startX, 2) + Math.pow(midY - startY, 2))
                    const line2Width = Math.sqrt(Math.pow(endX - midX, 2) + Math.pow(endY - midY, 2))
                    const totalLen = line1Width + line2Width
                    const drawLen = totalLen * strokeProgress
                    ctx.beginPath()
                    ctx.moveTo(startX, startY)
                    if (drawLen < line1Width) {
                        // draw line 1
                        const ratio = drawLen / line1Width
                        ctx.lineTo(startX + (midX - startX) * ratio, startY + (midY - startY) * ratio)
                    } else {
                        // draw line 2
                        ctx.lineTo(midX, midY)
                        const ratio2 = (drawLen - line1Width) / line2Width
                        ctx.lineTo(midX + (endX - midX) * ratio2, midY + (endY - midY) * ratio2)
                    }
                } else if (state === "partially") {
                    // draw partially
                    const totalWidth = width * 0.6
                    const halfWidth = (totalWidth / 2) * strokeProgress
                    const centerX = width / 2
                    const centerY = height / 2
                    ctx.beginPath()
                    ctx.moveTo(centerX - halfWidth, centerY)
                    ctx.lineTo(centerX + halfWidth, centerY)
                }
                ctx.stroke()
                ctx.restore()
            }
            Behavior on strokeProgress {
                enabled: control.animationEnabled
                NumberAnimation {
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
    contentItem: FluText {
        text: control.text
        font: control.font
        color: control.textColor
        leftPadding: control.textRight ? control.indicator.width + control.spacing : 0
        rightPadding: control.textRight ? 0 : control.indicator.width + control.spacing
        verticalAlignment: Text.AlignVCenter
    }
    onToggled: {
        clickListener()
    }
}
