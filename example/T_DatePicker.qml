import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

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
