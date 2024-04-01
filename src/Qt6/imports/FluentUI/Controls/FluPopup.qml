import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Popup {
    id: control
    padding: 0
    modal:true
    parent: Overlay.overlay
    x: Math.round((d.parentWidth - width) / 2)
    y: Math.round((d.parentHeight - height) / 2)
    closePolicy: Popup.NoAutoClose
    enter: Transition {
        NumberAnimation {
            property: "opacity"
            duration: FluTheme.animationEnabled ? 83 : 0
            from:0
            to:1
        }
    }
    height:Math.min(implicitHeight,d.parentHeight)
    exit:Transition {
        NumberAnimation {
            property: "opacity"
            duration: FluTheme.animationEnabled ? 83 : 0
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
    QtObject{
        id:d
        property int parentHeight: {
            if(control.parent){
                return control.parent.height
            }
            return control.height
        }
        property int parentWidth: {
            if(control.parent){
                return control.parent.width
            }
            return control.width
        }
    }
}
