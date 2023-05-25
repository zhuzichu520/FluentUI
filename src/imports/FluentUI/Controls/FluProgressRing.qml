import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
Rectangle {
    property real linWidth : width/8
    property real progress: 0.25
    property bool indeterminate: true
    readonly property real radius2 : radius - linWidth/2
    property color primaryColor : G.FluTheme.dark ? G.FluTheme.primaryColor.lighter : G.FluTheme.primaryColor.dark
    id: control
    width: 44
    height: 44
    radius: width/2
    border.width: linWidth
    color: "#00000000"
    border.color: G.FluTheme.dark ? Qt.rgba(99/255,99/255,99/255,1) : Qt.rgba(214/255,214/255,214/255,1)
    onProgressChanged: {
        canvas.requestPaint()
    }
    Component.onCompleted: {
        if(indeterminate){
            behavior.enabled = true
            control.rotation = 360
        }
    }
    Connections{
        target: G.FluTheme.getJsValue()
        function onDarkChanged(){
            canvas.requestPaint()
        }
    }
    Behavior on rotation{
        id:behavior
        enabled: false
        NumberAnimation{
            duration: 999
            easing.type: Easing.Bezier
            easing.bezierCurve: [0.55,0.55,0,1]
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
            ctx.restore();
        }
    }
}
