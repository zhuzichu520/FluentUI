import QtQuick
import QtQuick.Controls.impl
import FluentUI
import QtQuick.Templates as T

T.Button {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    horizontalPadding: 0
    spacing: 0
    contentItem: Item{}
    focusPolicy:Qt.TabFocus
    background: Item{
        FluFocusRectangle{
            visible: control.activeFocus
            radius:8
        }
    }
}
