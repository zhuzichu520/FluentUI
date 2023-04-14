import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls  2.15
import FluentUI 1.0
import "./component"

FluScrollablePage{

    title:"CheckBox"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
        Row{
            spacing: 30
            anchors.verticalCenter: parent.verticalCenter
            FluCheckBox{
            }
            FluCheckBox{
                text:"Text"
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        code:'FluCheckBox{
    text:"Text"
}'
    }

}
