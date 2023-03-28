import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluScrollablePage{

    title:"CalendarPicker"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    FluArea{
        width: parent.width
        Layout.topMargin: 20
        height: 350
        paddings: 10
        FluCalendarView{
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
            FluCalendarPicker{
            }
        }
    }

}
