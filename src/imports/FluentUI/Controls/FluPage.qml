import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Item {
    property int pageMode: FluNavigationView.SingleTop
    property string url
    id: control
    visible: false
    opacity: visible
    Behavior on opacity {
        NumberAnimation{
            duration: 83
        }
    }
}
