import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("ColorPicker")

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 60
        paddings: 10
        RowLayout{
            FluText{
                text: qsTr("Click to Select a Color - >")
                Layout.alignment: Qt.AlignVCenter
            }
            FluColorPicker{
                cancelText: qsTr("Cancel")
                okText: qsTr("OK")
                titleText: qsTr("Color Picker")
                editText: qsTr("Edit Color")
                redText: qsTr("Red")
                greenText: qsTr("Green")
                blueText: qsTr("Blue")
                opacityText: qsTr("Opacity")
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluColorPicker{

}'
    }

}

