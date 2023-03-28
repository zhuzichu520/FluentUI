import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluScrollablePage{

    title:"TabView"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    Component{
        id:com_page
        Rectangle{
            anchors.fill: parent
            color: argument
        }
    }

    Component.onCompleted: {
        var colors = [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]
        for(var i =0;i<colors.length;i++){
            tab_view.appendTab("","Document "+i,com_page,colors[i].dark)
        }
    }

    FluArea{
        width: parent.width
        Layout.topMargin: 20
        height: 400
        paddings: 10


        FluTabView{
            id:tab_view
        }


    }


}
