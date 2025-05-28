import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Rectangle")

    FluFrame{
        Layout.fillWidth: true
        padding: 10

        Flow{
            width: parent.width
            spacing: 15
            FluRectangle{
                width: 50
                height: 50
                color:"#0078d4"
                radius:[0,0,0,0]
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#744da9"
                radius:[15,15,15,15]
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#ffeb3b"
                radius:[15,0,0,0]
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#f7630c"
                radius:[0,15,0,0]
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#e71123"
                radius:[0,0,15,0]
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#b4009e"
                radius:[0,0,0,15]
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#a8d5ba"
                radius:[15,15,15,15]
                borderWidth: 3
                borderColor: "#5b8a72"
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#dbe2ef"
                radius:[15,0,0,0]
                borderWidth: 2
                borderColor: "#3f72af"
            }
            FluRectangle{
                width: 50
                height: 50
                color:"#dbe2ef"
                borderWidth: 2
                borderColor: "#3f72af"
                borderStyle: Qt.DashLine
                dashPattern: [4,2]
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluRectangle{
    radius: [25,25,25,25]
    borderWidth: 2
    borderColor: "#000000"
    borderStyle: Qt.DashLine
    dashPattern: [4,2]
    width: 50
    height: 50
}'
    }
}
