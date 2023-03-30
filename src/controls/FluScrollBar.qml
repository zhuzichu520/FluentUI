import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T
import FluentUI

T.ScrollBar {
    id: control

    property color handleNormalColor: Qt.rgba(134/255,134/255,134/255,1)
    property color handleHoverColor: Qt.lighter(handleNormalColor)
    property color handlePressColor: Qt.darker(handleNormalColor)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 4
    visible: control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: 0.3

    contentItem: Rectangle {
        implicitWidth: hovered || pressed ? 6 : 2
        implicitHeight:  hovered || pressed ? 6 : 2
        radius: width / 2
        layer.samples: 4
        layer.enabled: true
        layer.smooth: true
        color: control.pressed?handlePressColor:control.hovered?handleHoverColor:handleNormalColor
        opacity:(control.policy === T.ScrollBar.AlwaysOn || control.size < 1.0)?1.0:0.0
    }
    Behavior on implicitWidth {
        NumberAnimation{
            duration: 150
        }
    }

}
