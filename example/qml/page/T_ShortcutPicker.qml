import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("ShortcutPicker")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: childrenRect.height
        ColumnLayout{
            anchors.verticalCenter: parent.verticalCenter
            Item{
                Layout.preferredHeight: 15
            }
            Repeater{
                model: FluApp.launcher.hotkeys.children
                delegate: FluShortcutPicker{
                    text: model.name
                    syncHotkey: FluApp.launcher.hotkeys.children[index]
                    Layout.leftMargin: 15
                }
            }
            Item{
                Layout.preferredHeight: 15
            }
        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluShortcutPicker{

}'
    }

}
