import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("TimePicker")
    launchMode: FluPageType.SingleInstance
    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 80
        padding: 10

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
        Layout.topMargin: -6
        code:'FluTimePicker{

}'
    }

    FluFrame{
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
        Layout.topMargin: -6
        code:'FluTimePicker{
    hourFormat:FluTimePickerType.HH
}'
    }

}
