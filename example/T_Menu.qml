import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluScrollablePage{

    title:"Menu"

    FluButton{
        text:"左击菜单"
        Layout.topMargin: 20
        Layout.leftMargin: 15
        onClicked:{
            menu.popup()
        }
    }


    FluButton{
        text:"右击菜单"
        Layout.topMargin: 20
        Layout.leftMargin: 15
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
