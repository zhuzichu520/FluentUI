import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("Text")

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 60
        paddings: 10

        FluCopyableText{
            text: qsTr("This is a text that can be copied")
            anchors.verticalCenter: parent.verticalCenter
        }

    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluCopyableText{
    text: qsTr("This is a text that can be copied")
}'
    }

}
