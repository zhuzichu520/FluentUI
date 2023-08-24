import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

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
