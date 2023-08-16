import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Loader {
    id:control
    Component{
        id:com_screen
        Window{
            id:window_screen
            flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
            width: Screen.desktopAvailableWidth
            height: Screen.height
            visible: true
            color: "#00000000"
            onVisibleChanged: {
                if(!window_screen.visible){
                    control.sourceComponent = undefined
                }
            }
            Screenshot{
                id:screenshot
                anchors.fill: parent
            }
            MouseArea{
                property bool enablePosition: false
                anchors.fill: parent
                acceptedButtons: Qt.RightButton |  Qt.LeftButton
                onPressed:
                    (mouse)=>{
                        if(mouse.button === Qt.LeftButton){
                            enablePosition = true
                            screenshot.start = Qt.point(mouse.x,mouse.y)
                            screenshot.end = Qt.point(mouse.x,mouse.y)
                        }
                    }
                onPositionChanged:
                    (mouse)=>{
                        if(enablePosition){
                            screenshot.end = Qt.point(mouse.x,mouse.y)
                        }
                    }
                onReleased:
                    (mouse)=>{
                        if(mouse.button === Qt.LeftButton){
                            enablePosition = false
                            screenshot.end = Qt.point(mouse.x,mouse.y)
                        }
                    }
                onClicked:
                    (mouse)=>{
                        if (mouse.button === Qt.RightButton){
                            if(screenshot.start === Qt.point(0,0) && screenshot.end === Qt.point(0,0)){
                                control.sourceComponent = undefined
                                return
                            }
                            screenshot.start = Qt.point(0,0)
                            screenshot.end = Qt.point(0,0)
                        }
                    }
            }
            Rectangle{
                id:rect_capture
                x:Math.min(screenshot.start.x,screenshot.end.x)
                y:Math.min(screenshot.start.y,screenshot.end.y)
                width: Math.abs(screenshot.end.x - screenshot.start.x)
                height: Math.abs(screenshot.end.y - screenshot.start.y)
                color:"#00000000"
                border.width: 1
                border.color: FluTheme.primaryColor.dark
                MouseArea{
                    property point clickPos: Qt.point(0,0)
                    anchors.fill: parent
                    cursorShape: Qt.SizeAllCursor
                    onPressed:
                        (mouse)=>{
                            clickPos = Qt.point(mouse.x, mouse.y)
                        }
                    onPositionChanged:
                        (mouse)=>{
                            var delta = Qt.point(mouse.x - clickPos.x,mouse.y - clickPos.y)
                            var w = Math.abs(screenshot.end.x - screenshot.start.x)
                            var h = Math.abs(screenshot.end.y - screenshot.start.y)
                            var x = Math.min(Math.max(rect_capture.x + delta.x,0),window_screen.width-w)
                            var y =Math.min(Math.max(rect_capture.y + delta.y,0),window_screen.height-h)
                            screenshot.start = Qt.point(x,y)
                            screenshot.end = Qt.point(x+w,y+h)
                        }
                }
            }
        }
    }

    function open(){
        control.sourceComponent = com_screen
    }
}
