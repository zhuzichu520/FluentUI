import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("ShortcutPicker")

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        FluShortcutPicker{
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluShortcutPicker{

}'
    }

}


