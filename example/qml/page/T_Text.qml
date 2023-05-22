import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title:"Text"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 60
        paddings: 10

        FluCopyableText{
            text: "这是一个可以支持复制的Text"
            anchors.verticalCenter: parent.verticalCenter
        }

    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluCopyableText{
    text:"这是一个可以支持复制的Text"
}'
    }

}
