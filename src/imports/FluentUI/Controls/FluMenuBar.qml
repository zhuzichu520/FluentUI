import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15

T.MenuBar {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    delegate: FluMenuBarItem { }
    contentItem: Row {
        spacing: control.spacing
        Repeater {
            model: control.contentModel
        }
    }
    background: Item {
        implicitHeight: 30
    }
}
