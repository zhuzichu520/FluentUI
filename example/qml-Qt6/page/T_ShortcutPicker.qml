import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("ShortcutPicker")

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 100
        paddings: 10
        FluShortcutPicker{
            anchors.verticalCenter: parent.verticalCenter
            title: qsTr("Activate the Shortcut")
            message: qsTr("Press the key combination to change the shortcut")
            positiveText: qsTr("Save")
            neutralText: qsTr("Cancel")
            negativeText: qsTr("Reset")
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluShortcutPicker{

}'
    }

}

