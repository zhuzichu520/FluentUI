import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("DatePicker")

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        padding: 10
        ColumnLayout{
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("showYear=true")
            }
            FluDatePicker{
                current: new Date()
                onAccepted: {
                    showSuccess(current.toLocaleDateString())
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluDatePicker{

}'
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.preferredHeight: 80
        padding: 10
        ColumnLayout{
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("showYear=false")
            }
            FluDatePicker{
                showYear: false
                onAccepted: {
                    showSuccess(current.toLocaleDateString())
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluDatePicker{
    showYear:false
}'
    }

}
