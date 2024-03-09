import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
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
