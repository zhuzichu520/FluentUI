import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import FluentUI

T.MenuSeparator {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    verticalPadding: 0
    contentItem: Rectangle {
        implicitWidth: 188
        implicitHeight: 1
        color: FluTheme.dark ? Qt.rgba(60/255,60/255,60/255,1) : Qt.rgba(210/255,210/255,210/255,1)
    }
}
