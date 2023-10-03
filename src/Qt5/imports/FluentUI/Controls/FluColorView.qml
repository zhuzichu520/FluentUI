import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "ColorPicker"

Item {
    id:control
    property alias colorValue: color_picker.colorValue
    property alias enableAlphaChannel: color_picker.enableAlphaChannel
    property int radius: 5
    width: color_picker.width+10
    height: color_picker.height
    FluArea{
        anchors.fill: parent
        radius: control.radius
        ColorPicker{
            id:color_picker
        }
    }
    function setColor(color) {
        color_picker.setColor(color)
    }
}

