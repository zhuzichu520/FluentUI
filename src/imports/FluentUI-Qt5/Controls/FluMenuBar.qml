import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12

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
