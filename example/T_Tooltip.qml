import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluScrollablePage{

    title:"Tooltip"

    FluText{
        Layout.topMargin: 20
        text:"鼠标悬停不动，弹出Tooltip"
    }


    FluArea{
        width: parent.width
        Layout.topMargin: 20
        height: 68
        paddings: 10

        Column{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text:"FluIconButton的text属性自带Tooltip效果"
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeCloseContrast
                iconSize: 15
                text:"删除"
                onClicked:{
                    showSuccess("点击IconButton")
                }
            }
        }
    }

    FluArea{
        width: parent.width
        Layout.topMargin: 20
        height: 68
        paddings: 10

        Column{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text:"给一个Button添加Tooltip效果"
            }
            FluButton{
                id:button_1
                text:"删除"
                onClicked:{
                    showSuccess("点击一个Button")
                }
                FluTooltip{
                    visible: button_1.hovered
                    text:button_1.text
                    delay: 1000
                }
            }
        }
    }


}
