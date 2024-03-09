import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("TimePicker")
    launchMode: FluPageType.SingleInstance
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
                text: qsTr("hourFormat=FluTimePickerType.H")
            }

            FluTimePicker{
                current: new Date()
                amText: qsTr("AM")
                pmText: qsTr("PM")
                hourText: qsTr("Hour")
                minuteText: qsTr("Minute")
                cancelText: qsTr("Cancel")
                okText: qsTr("OK")
                onAccepted: {
                    showSuccess(current.toLocaleTimeString(Qt.locale("de_DE")))
                }
            }

        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluTimePicker{

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
                text: qsTr("hourFormat=FluTimePickerType.HH")
            }

            FluTimePicker{
                hourFormat:FluTimePickerType.HH
                amText: qsTr("AM")
                pmText: qsTr("PM")
                hourText: qsTr("Hour")
                minuteText: qsTr("Minute")
                cancelText: qsTr("Cancel")
                okText: qsTr("OK")
                onAccepted: {
                    showSuccess(current.toLocaleTimeString(Qt.locale("de_DE")))
                }
            }

        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluTimePicker{
    hourFormat:FluTimePickerType.HH
}'
    }

}
