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
        Layout.preferredHeight: 80
        padding: 10

        Column{
            spacing: 15
            anchors{
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            RowLayout{
                Layout.topMargin: 20
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
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluRectangle{
    radius: [25,25,25,25]
    width: 50
    height: 50
}'
    }
}
