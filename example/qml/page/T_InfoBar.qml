import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("InfoBar")

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 270
        paddings: 10
        ColumnLayout{
            spacing: 14
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluButton{
                text: qsTr("Info")
                onClicked: {
                    showInfo(qsTr("This is an InfoBar in the Info Style"))
                }
            }
            FluButton{
                text: qsTr("Warning")
                onClicked: {
                    showWarning(qsTr("This is an InfoBar in the Warning Style"))
                }
            }
            FluButton{
                text:"Error"
                onClicked: {
                    showError(qsTr("This is an InfoBar in the Error Style"))
                }
            }
            FluButton{
                text:"Success"
                onClicked: {
                    showSuccess(qsTr("This is an InfoBar in the Success Style"))
                }
            }
            FluButton{
                text: qsTr("InfoBar that needs to be turned off manually")
                onClicked: {
                    showInfo("This is an InfoBar in the Info Style",0,"Manual shutdown is supported")
                }
            }
            FluButton{
                text:"Loading"
                onClicked: {
                    showLoading(qsTr("Loading..."))
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'showInfo(qsTr("This is an InfoBar in the Info Style"))

showWarning(qsTr("This is an InfoBar in the Warning Style"))

showError(qsTr("This is an InfoBar in the Error Style"))

showSuccess(qsTr("This is an InfoBar in the Success Style"))'
    }
}
