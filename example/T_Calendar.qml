import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

FluScrollablePage{

    title:"Calendar"


    FluArea{
        width: parent.width
        Layout.topMargin: 20
        height: 350
        paddings: 10


        FluCalendarView{

        }

    }


}
