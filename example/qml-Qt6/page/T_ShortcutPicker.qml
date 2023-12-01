import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"ShortcutPicker"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 100
        paddings: 10
        FluShortcutPicker{
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluShortcutPicker{

}'
    }

}

