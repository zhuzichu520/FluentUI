import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("GroupBox")

    FluGroupBox {
        title: qsTr("CheckBox Group")
        ColumnLayout {
            spacing: 10
            anchors.fill: parent
            FluCheckBox { text: qsTr("E-mail") }
            FluCheckBox { text: qsTr("Calendar") }
            FluCheckBox { text: qsTr("Contacts") }
        }
    }

    FluGroupBox {
        title: qsTr("RadioButton Group")
        Layout.fillWidth: true
        Layout.preferredHeight: 150
        Layout.topMargin: 20
        FluRadioButtons {
            orientation: orientation_switch.checked ? Qt.Vertical : Qt.Horizontal
            spacing: 10
            disabled: disabled_switch.checked
            FluRadioButton { text: qsTr("E-mail") }
            FluRadioButton { text: qsTr("Calendar") }
            FluRadioButton { text: qsTr("Contacts") }
        }
        ColumnLayout {
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            FluToggleSwitch{
                id: disabled_switch
                text: qsTr("Disabled")
            }

            FluToggleSwitch{
                id: orientation_switch
                text: qsTr("Orientation")
            }
        }

    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: 4
        code:`
FluGroupBox {
    title: qsTr("CheckBox Group")
    ColumnLayout {
        spacing: 10
        anchors.fill: parent
        FluCheckBox { text: qsTr("E-mail") }
        FluCheckBox { text: qsTr("Calendar") }
        FluCheckBox { text: qsTr("Contacts") }
    }
}

FluGroupBox {
    title: qsTr("RadioButton Group")
    FluRadioButtons {
        spacing: 10
        orientation: Qt.Vertical // Qt.Horizontal
        disabled: true // 禁用所有FluRadioButton子组件
        manuallyDisabled: true // 是否指定每个FluRadioButton上的disabled选项
        FluRadioButton { text: qsTr("E-mail") }
        FluRadioButton { text: qsTr("Calendar") }
        FluRadioButton { text: qsTr("Contacts") }
    }
}
`
    }

}
