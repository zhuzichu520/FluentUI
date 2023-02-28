import QtQuick 2.12
import QtQuick.Controls 2.12

//进度条4
Rectangle {
    id: control

    width: 60
    height: 60
    radius: 30
    border.width: linWidth
    color: "#00000000"
    border.color: Qt.rgba(214/255,214/255,214/255,1)
    property real linWidth : 6
    property real progress: 0.25
    property bool indeterminate: true
    readonly property real radius2 : radius - linWidth/2
    property color primaryColor : Qt.rgba(0/255,102/255,180/255,1)

    onProgressChanged: {
        canvas.requestPaint()
    }

    Behavior on rotation{
        id:anim
        enabled: true
        NumberAnimation{
            duration: 800
            onRunningChanged: {
                if(!running){
                    anim.enabled = false
                    control.rotation = 0
                    anim.enabled = true
                    timer.start()
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

    Timer{
        id:timer
        running: indeterminate
        interval: 800
        triggeredOnStart: true
        onTriggered: {
            control.rotation = 360
        }
    }

}
