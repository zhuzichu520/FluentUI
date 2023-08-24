import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "qrc:///example/qml/component"

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
