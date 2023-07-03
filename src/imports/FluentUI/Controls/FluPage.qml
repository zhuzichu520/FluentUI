import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Item {
    property int pageMode: FluNavigationView.SingleTop
    property bool animDisabled: false
    property string url : ""
    id: control
    opacity: visible
    visible: false
    Behavior on opacity{
        enabled: !animDisabled
        NumberAnimation{
            duration: 167
        }
    }
    transform: Translate {
        y: control.visible ? 0 : 80
        Behavior on y{
            enabled: !animDisabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
    }
    Component.onCompleted: {
        visible = true
    }
}
