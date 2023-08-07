import QtQuick
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Popup{

    property var steps : []
    id:control
    padding: 0
    anchors.centerIn: Overlay.overlay
    width: d.window?.width
    height: d.window?.height

    background: Item{}

    contentItem: Item{}


    property int index: 0
    property var step : steps[index]
    property var target : step.target()

    onVisibleChanged: {
        if(visible){
            index = 0
        }
    }


    Connections{
        target: d.window
        function onWidthChanged(){
            canvas.requestPaint()
        }
        function onHeightChanged(){
            canvas.requestPaint()
        }
    }

    onIndexChanged: {
        canvas.requestPaint()
    }

    Item{
        id:d
        property var window: Window.window
        property var pos:Qt.point(0,0)
    }

    Canvas{
        id:canvas
        anchors.fill: parent
        onPaint: {
            d.pos = target.mapToItem(control,0,0)
            var ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvasSize.width, canvasSize.height);
            ctx.save()
            ctx.fillStyle = "#66000000"
            ctx.fillRect(0, 0, canvasSize.width, canvasSize.height)
            ctx.globalCompositeOperation = 'destination-out'
            ctx.fillStyle = 'black'
            console.debug(d.pos.x)
            ctx.fillRect(d.pos.x, d.pos.y, target.width, target.height)
            ctx.restore()
        }
    }

    FluRectangle{
        radius: [5,5,5,5]
        width: 500
        height: 120
        x: Math.min(Math.max(0,d.pos.x+target.width/2-width/2),d.window?.width-width)
        y:d.pos.y+target.height+1
        FluFilledButton{
            property bool isEnd: control.index === steps.length-1
            anchors{
                right: parent.right
                bottom: parent.bottom
                rightMargin: 10
                bottomMargin: 10
            }
            text: isEnd ? "结束导览" :"下一步"
            onClicked: {
                if(isEnd){
                    control.close()
                }else{
                    control.index = control.index + 1
                }
            }
        }
    }


    function refresh(){
        canvas.requestPaint()
    }

}


