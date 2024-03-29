import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("ColorPicker")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        padding: 10
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
        Layout.topMargin: -6
        code:'FluColorPicker{

}'
    }

}
