import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

FluScrollablePage{

    title:"Menu"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    FluButton{
        text:"左击菜单"
        Layout.topMargin: 20
        onClicked:{
            menu.popup()
        }
    }


    FluButton{
        text:"右击菜单"
        Layout.topMargin: 20
        onClicked: {
            showSuccess("请按鼠标右击")
        }
        MouseArea{
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: {
                menu.popup()
            }
        }
    }

    FluMenu{
        id:menu
        FluMenuItem{
            text:"删除"
            onClicked: {
                showError("删除")
            }
        }
        FluMenuItem{
            text:"修改"
            onClicked: {
                showError("修改")
            }
        }
    }

}
