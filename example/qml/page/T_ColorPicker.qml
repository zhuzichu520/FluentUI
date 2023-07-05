import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import FluentUI 1.0
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"ColorPicker"

    FluArea{
        Layout.fillWidth: true
        height: 280
        Layout.topMargin: 20
        paddings: 10
        ColumnLayout{
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }
            FluText{
                text:"此颜色组件是Github上的开源项目"
            }
            FluTextButton{
                text:"https://github.com/rshest/qml-colorpicker"
                onClicked: {
                    Qt.openUrlExternally(text)
                }
            }
            FluColorView{

            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluColorView{

}'
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 60
        paddings: 10

        RowLayout{
            FluText{
                text:"点击选择颜色->"
                Layout.alignment: Qt.AlignVCenter
            }
            FluColorPicker{

            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluColorPicker{

}'
    }

}

