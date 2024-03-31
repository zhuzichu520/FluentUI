import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Sheet")

    FluSheet{
        id:sheet
        title: qsTr("Title")
        FluText{
            text: qsTr("Some contents...\nSome contents...\nSome contents...")
            anchors{
                left: parent.left
                leftMargin: 10
            }
        }
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 280
        padding: 10
        Column{
            anchors.centerIn: parent
            spacing: 10
            Row{
                spacing: 10
                FluButton{
                    width: 80
                    height: 30
                    text: qsTr("top")
                    onClicked: {
                        sheet.open(FluSheetType.Top)
                    }
                }
                FluButton{
                    width: 80
                    height: 30
                    text: qsTr("right")
                    onClicked: {
                        sheet.open(FluSheetType.Right)
                    }
                }
            }
            Row{
                spacing: 10
                FluButton{
                    width: 80
                    height: 30
                    text: qsTr("bottom")
                    onClicked: {
                        sheet.open(FluSheetType.Bottom)
                    }
                }
                FluButton{
                    width: 80
                    height: 30
                    text: qsTr("left")
                    onClicked: {
                        sheet.open(FluSheetType.Left)
                    }
                }
            }
        }
    }

    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluSheet{
    id:sheet
    title: qsTr("Title")
    FluText{
        text: qsTr("Some contents...")
        anchors{
            left: parent.left
            leftMargin: 10
        }
    }
}
sheet.open(FluSheetType.Bottom)
'
    }

}
