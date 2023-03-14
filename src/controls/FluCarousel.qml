import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {


    id:control

    property int position: 1

    property bool flagXChanged: true

    width: 400
    height: 300


    ListModel{
        id:content_model
    }

    ListView{
        id:list_view
        anchors.fill: parent
        snapMode: ListView.SnapOneItem
        clip: true
        boundsBehavior: ListView.StopAtBounds
        model:content_model
        delegate: Rectangle{
            width: ListView.view.width
            height: ListView.view.height
            color:model.color

            property int displayIndex: {
                if(index === 0)
                    return content_model.count-3
                if(index === content_model.count-1)
                    return 0
                return index-1
            }

            Text{
                color:"red"
                text: displayIndex
                font.pixelSize: 32
                anchors.centerIn: parent
            }

        }
        Timer{
            id:tiemr
            interval: 100
            onTriggered: {
                control.position = list_view.contentX/list_view.width
            }
        }
        onMovementEnded:{
            flagXChanged = false
            tiemr.restart()
        }
        onMovementStarted: {
            flagXChanged = true
        }
        onContentXChanged: {
            if(flagXChanged){
                var maxX = Math.min(list_view.width*(control.position+1),list_view.count*list_view.width)
                var minY = Math.max(0,(list_view.width*(control.position-1)))
                if(contentX>=maxX){
                    contentX = maxX
                }
                if(contentX<=minY){
                    contentX = minY
                }
            }
        }
        orientation : ListView.Horizontal
    }

    onPositionChanged: {
        if(control.position === 0){
            position = list_view.count-2
            list_view.positionViewAtIndex(list_view.count-2, ListView.Beginning)

        }
        if(control.position === list_view.count-1){
            position = 1
            list_view.positionViewAtIndex(1, ListView.Beginning)

        }
    }

    function setData(data){
        content_model.clear()
        content_model.append(data[data.length-1])
        content_model.append(data)
        content_model.append(data[0])
        list_view.positionViewAtIndex(1, ListView.Beginning)
        position = 1
    }
}

