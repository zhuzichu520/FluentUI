import QtQuick
import "../colorpicker"

Item {

    width: color_picker.width+10
    height: color_picker.height

    property alias colorValue: color_picker.colorValue

    FluArea{
        anchors.fill: parent
        radius: 5

        FluShadow{
            radius: 5
        }

        ColorPicker{
            id:color_picker
        }
    }

    function setColor(color) {
        color_picker.setColor(color)
    }

}

