import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import FluentUI 1.0

Popup {
    id: popup
    padding: 0
    modal:true
    anchors.centerIn: Overlay.overlay
    closePolicy: Popup.CloseOnEscape
    property alias blurSource: blur.sourceItem
    property bool blurBackground: true
    property alias blurOpacity: blur.acrylicOpacity
    property alias blurRectX: blur.rectX
    property alias blurRectY: blur.rectY
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

    background: FluAcrylic{
        id:blur
        color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(249/255,249/255,249/255,1)
        rectX: popup.x
        rectY: popup.y
        acrylicOpacity:blurBackground ? 0.8 : 1
    }
}
