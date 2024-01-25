import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title:"TimePicker"
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
                text:"hourFormat=FluTimePickerType.H"
            }

            FluTimePicker{
                current: new Date()
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
                text:"hourFormat=FluTimePickerType.HH"
            }

            FluTimePicker{
                hourFormat:FluTimePickerType.HH
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
