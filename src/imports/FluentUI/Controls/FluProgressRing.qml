import QtQuick
import QtQuick.Controls
import FluentUI

Rectangle {
    property real linWidth : width/8
    property real progress: 0.25
    property bool indeterminate: true
    property color primaryColor : FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property bool progressVisible: false
    id: control
    width: 44
    height: 44
    radius: width/2
    border.width: linWidth
    color: "#00000000"
    border.color: FluTheme.dark ? Qt.rgba(99/255,99/255,99/255,1) : Qt.rgba(214/255,214/255,214/255,1)
    onProgressChanged: {
        canvas.requestPaint()
    }
    Component.onCompleted: {
        if(indeterminate){
            behavior.enabled = true
            control.rotation = 360
        }
    }
    QtObject{
        id:d
        property real _radius: control.radius-control.linWidth/2
    }
    Connections{
        target: FluTheme
        function onDarkChanged(){
            canvas.requestPaint()
        }
    }
    Behavior on rotation{
        id:behavior
        enabled: false
        NumberAnimation{
            duration: 999
            easing.type: Easing.BezierSpline
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
            var ctx = canvas.getContext("2d")
            ctx.setTransform(1, 0, 0, 1, 0, 0)
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.save()
            ctx.lineWidth = linWidth
            ctx.strokeStyle = primaryColor
            ctx.fillStyle = primaryColor
            ctx.beginPath()
            ctx.arc(width/2, height/2, d._radius ,-0.5 * Math.PI,-0.5 * Math.PI + progress * 2 * Math.PI)
            ctx.stroke()
            ctx.closePath()
            ctx.restore()
        }
    }
    FluText{
        text:(control.progress * 100).toFixed(0) + "%"
        font.pixelSize: 10
        visible: {
            if(control.indeterminate){
                return false
            }
            return control.progressVisible
        }
        anchors.centerIn: parent
    }
}
