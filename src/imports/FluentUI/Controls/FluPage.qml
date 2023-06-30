import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Item {
    property int pageMode: FluNavigationView.SingleTop
    property string url : ""
    id: control
    opacity: visible
    visible: false
    Behavior on opacity{
        NumberAnimation{
            duration: 83
        }
    }
    Component.onCompleted: {
        visible = true
    }
}
