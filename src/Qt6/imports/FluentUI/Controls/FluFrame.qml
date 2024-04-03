import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import FluentUI

T.Frame {
    property alias border: d.border
    property alias color: d.color
    property alias radius: d.radius
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    padding: 0
    background: Rectangle {
        id:d
        radius: 4
        border.color: FluTheme.dark ? Window.active ? Qt.rgba(55/255,55/255,55/255,1):Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
        color: FluTheme.dark ? Window.active ?  Qt.rgba(28/255,28/255,28/255,1) : Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    }
}
