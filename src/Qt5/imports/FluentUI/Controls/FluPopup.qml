import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FluentUI 1.0

Popup {
    id: popup
    padding: 0
    modal:true
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    closePolicy: Popup.CloseOnEscape
    enter: Transition {
        NumberAnimation {
            property: "opacity"
            duration: FluTheme.enableAnimation ? 83 : 0
            from:0
            to:1
        }
    }
    exit:Transition {
        NumberAnimation {
            property: "opacity"
            duration: FluTheme.enableAnimation ? 83 : 0
            from:1
            to:0
        }
    }
    background: FluRectangle{
        radius: [5,5,5,5]
        color: FluTheme.dark ? Qt.rgba(43/255,43/255,43/255,1) : Qt.rgba(1,1,1,1)
        FluShadow{
            radius: 5
        }
    }
}
