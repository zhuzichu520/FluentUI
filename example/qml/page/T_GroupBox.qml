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
        FluRadioButtons {
            spacing: 10
            FluRadioButton { text: qsTr("E-mail") }
            FluRadioButton { text: qsTr("Calendar") }
            FluRadioButton { text: qsTr("Contacts") }
        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: 4
        code:'FluGroupBox {
    title: qsTr("CheckBox Group")
    ColumnLayout {
        spacing: 10
        anchors.fill: parent
        FluCheckBox { text: qsTr("E-mail") }
        FluCheckBox { text: qsTr("Calendar") }
        FluCheckBox { text: qsTr("Contacts") }
    }
}'
    }

}
