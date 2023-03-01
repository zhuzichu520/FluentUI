import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: control

    width: 60
    height: 60
    radius: 30
    border.width: linWidth
    color: "#00000000"
    border.color: FluApp.isDark ? Qt.rgba(41/255,41/255,41/255,1) : Qt.rgba(214/255,214/255,214/255,1)
    property real linWidth : 6
    property real progress: 0.25
    property bool indeterminate: true
    readonly property real radius2 : radius - linWidth/2
    property color primaryColor : FluApp.isDark ? Qt.rgba(76/255,160/255,224/255,1) : Qt.rgba(0/255,102/255,180/255,1)

    onProgressChanged: {
        canvas.requestPaint()
    }

    Connections{
        target: FluApp
        function onIsDarkChanged(isDark){
            canvas.requestPaint()
        }
    }

    Component.onCompleted: {
        if(indeterminate){
            behavior.enabled = true
            control.rotation = 360
        }
    }

    Behavior on rotation{
        id:behavior
        enabled: false
        NumberAnimation{
            duration: 1000
            onRunningChanged: {
                if(!running){
                    behavior.enabled = false
                    control.rotation = 0
                    behavior.enabled = true
                    control.rotation = 360
                }
            }
        }
    }

    Canvas {
        id:canvas
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.Image
        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.save();
            ctx.lineWidth = linWidth;
            ctx.strokeStyle = primaryColor;
            ctx.fillStyle = primaryColor;
            ctx.beginPath();
            ctx.arc(width/2, height/2, radius2 ,-0.5 * Math.PI,-0.5 * Math.PI + progress * 2 * Math.PI);
            ctx.stroke();
            ctx.closePath();
            //            var start_x = width/2 + Math.cos(-0.5 * Math.PI) * radius2;
            //            var start_y = height/2 + Math.sin(-0.5 * Math.PI) * radius2;
            //            ctx.beginPath();
            //            ctx.arc(start_x, start_y, 3, 0, 2*Math.PI);
            //            ctx.fill();
            //            ctx.closePath();
            //            var end_x = width/2 + Math.cos(-0.5 * Math.PI + progress * 2 * Math.PI) * radius2;
            //            var end_y = height/2 + Math.sin(-0.5 * Math.PI + progress * 2 * Math.PI) * radius2;
            //            ctx.beginPath();
            //            ctx.arc(end_x, end_y, 3, 0, 2*Math.PI);
            //            ctx.fill();
            //            ctx.closePath();
            ctx.restore();
        }
    }


}
