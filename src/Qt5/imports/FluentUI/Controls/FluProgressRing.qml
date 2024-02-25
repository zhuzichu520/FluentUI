import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import FluentUI 1.0

ProgressBar{
    property int duration: 2000
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
        canvas.requestPaint()
    }
    QtObject{
        id:d
        property real _radius: control.width/2-control.strokeWidth/2
        property real _progress: control.indeterminate ? 0.0 :  control.visualPosition
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
        Canvas {
            id:canvas
            anchors.fill: parent
            antialiasing: true
            renderTarget: Canvas.Image
            property real startAngle: 0
            property real sweepAngle: 0
            SequentialAnimation on startAngle {
                loops: Animation.Infinite
                running: control.visible && control.indeterminate
                PropertyAnimation { from: 0; to: 450; duration: control.duration/2 }
                PropertyAnimation { from: 450; to: 1080; duration: control.duration/2 }
            }
            SequentialAnimation on sweepAngle {
                loops: Animation.Infinite
                running: control.visible && control.indeterminate
                PropertyAnimation { from: 0; to: 180; duration: control.duration/2 }
                PropertyAnimation { from: 180; to: 0; duration: control.duration/2 }
            }
            onStartAngleChanged: {
                requestPaint()
            }
            onPaint: {
                var ctx = canvas.getContext("2d")
                ctx.clearRect(0, 0, canvas.width, canvas.height)
                ctx.save()
                ctx.lineWidth = control.strokeWidth
                ctx.strokeStyle = control.color
                ctx.lineCap = "round"
                ctx.beginPath()
                if(control.indeterminate){
                    ctx.arc(width/2, height/2, d._radius , Math.PI * (startAngle - 90) / 180,  Math.PI * (startAngle - 90 + sweepAngle) / 180)
                }else{
                    ctx.arc(width/2, height/2, d._radius , -0.5 * Math.PI , -0.5 * Math.PI + d._progress * 2 * Math.PI)
                }
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
