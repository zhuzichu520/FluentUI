import QtQuick
import QtQuick.Controls.impl
import FluentUI
import QtQuick.Templates as T

T.Button {
    id: control
    property string contentDescription: ""
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
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
}
