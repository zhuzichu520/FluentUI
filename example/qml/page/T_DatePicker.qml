import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import FluentUI 1.0
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"TimePicker"

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
                text:"showYear=true"
            }
            FluDatePicker{
                onCurrentChanged: {
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
                text:"showYear=false"
            }

            FluDatePicker{
                showYear:false
                onCurrentChanged: {
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
