import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluContentPage{

    title:"StaggeredLayout"

    property var colors : [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]

    ListModel{
        id:list_model
        Component.onCompleted: {
            for(var i=0;i<=100;i++){
                var item = {}
                item.color = colors[rand(0,7)]
                item.height = rand(100,300)
                append(item)
            }
        }

    }

    Flickable{
        id: scroll
        anchors.fill: parent
        anchors.topMargin: 20
        boundsBehavior:Flickable.StopAtBounds
        contentHeight: staggered_view.implicitHeight
        clip: true
        ScrollBar.vertical: FluScrollBar {}
        FluStaggeredLayout{
            id:staggered_view
            width: parent.width
            itemWidth: 160
            model:list_model
            delegate: Rectangle{
                height: model.height
                color:model.color.normal
                FluText{
                    color:"#FFFFFF"
                    text:model.index
                    font.bold: true
                    font.pixelSize: 18
                    anchors.centerIn: parent
                }
            }
        }
    }

    function rand(minNum, maxNum){
        return parseInt(Math.random() * (maxNum - minNum + 1) + minNum, 10);
    }

}
