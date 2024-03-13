import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("TimePicker")

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 80
        paddings: 10
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
        Layout.topMargin: -1
        code:'FluDatePicker{

}'
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 80
        paddings: 10
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
                yearText: qsTr("Year")
                monthText: qsTr("Month")
                dayText: qsTr("Day")
                cancelText: qsTr("Cancel")
                okText: qsTr("OK")
                onAccepted: {
                    showSuccess(current.toLocaleDateString())
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluDatePicker{
    showYear:false
}'
    }

}
