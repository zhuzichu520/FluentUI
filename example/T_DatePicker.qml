import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluScrollablePage{

    title:"TimePicker"


    FluArea{
        width: parent.width
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
            }

        }
    }


    FluArea{
        width: parent.width
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

            }

        }
    }

}
