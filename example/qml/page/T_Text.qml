import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import FluentUI 1.0
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
//        Layout.topMargin: -1
        code:'FluCopyableText{
    text:"这是一个可以支持复制的Text"
}'
    }

}
