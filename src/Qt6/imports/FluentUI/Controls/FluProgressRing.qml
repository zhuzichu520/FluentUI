import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI

ProgressBar{
    property int duration: 888
    property real strokeWidth: 6
    property bool progressVisible: false
    property color color: FluTheme.primaryColor
    property color backgroundColor : FluTheme.dark ? Qt.rgba(99/255,99/255,99/255,1) : Qt.rgba(214/255,214/255,214/255,1)
    id:control
    indeterminate : true
    clip: true
    background: Rectangle {
        implicitWidth: 56
        implicitHeight: 56
        radius: control.width/2
        color:"transparent"
        border.color: control.backgroundColor
        border.width: control.strokeWidth
    }
    onIndeterminateChanged:{
        if(!indeterminate){
            animator_r.duration = 0
            layout_item.rotation = 0
            animator_r.duration = control.duration
        }
    }
    QtObject{
        id:d
        property real _radius: control.width/2-control.strokeWidth/2
        property real _progress: control.indeterminate ? 0.3 :  control.visualPosition
        on_ProgressChanged: {
            canvas.requestPaint()
        }
    }
    Connections{
        target: FluTheme
        function onDarkChanged(){
            canvas.requestPaint()
        }
    }
    contentItem: Item {
        id:layout_item
        RotationAnimation on rotation {
            id:animator_r
            running: control.indeterminate && control.visible
            from: 0
            to:360
            loops: Animation.Infinite
            duration: control.duration
        }
        Canvas {
            id:canvas
            anchors.fill: parent
            antialiasing: true
            renderTarget: Canvas.Image
            onPaint: {
                var ctx = canvas.getContext("2d")
                ctx.clearRect(0, 0, canvas.width, canvas.height)
                ctx.save()
                ctx.lineWidth = control.strokeWidth
                ctx.strokeStyle = control.color
                ctx.beginPath()
                ctx.arc(width/2, height/2, d._radius ,-0.5 * Math.PI,-0.5 * Math.PI + d._progress * 2 * Math.PI)
                ctx.stroke()
                ctx.closePath()
                ctx.restore()
            }
        }
    }
    FluText{
        text:(control.visualPosition * 100).toFixed(0) + "%"
        visible: {
            if(control.indeterminate){
                return false
            }
            return control.progressVisible
        }
        anchors.centerIn: parent
    }
}
