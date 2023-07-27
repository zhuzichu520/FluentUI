import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Popup {
    id: popup
    padding: 0
    modal:true
    anchors.centerIn: Overlay.overlay
    closePolicy: Popup.CloseOnEscape
    enter: Transition {
        NumberAnimation {
            properties: "scale"
            from:1.2
            to:1
            duration: FluTheme.enableAnimation ? 83 : 0
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            property: "opacity"
            duration: FluTheme.enableAnimation ? 83 : 0
            from:0
            to:1
        }
    }
    exit:Transition {
        NumberAnimation {
            properties: "scale"
            from:1
            to:1.2
            duration: FluTheme.enableAnimation ? 83 : 0
            easing.type: Easing.OutCubic
        }
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
    }
}
