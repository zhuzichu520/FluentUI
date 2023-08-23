import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI

Item{
    id:control
    property int captrueMode: FluScreenshotType.Pixmap
    property int dotSize: 5
    property int borderSize: 1
    property var saveFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    property color borderColor: FluTheme.primaryColor.dark
    signal captrueCompleted(var captrue)
    QtObject{
        id:d
        property int dotMouseSize: control.dotSize+10
        property int dotMargins: -(control.dotSize-control.borderSize)/2
        property bool enablePosition: false
        property int menuMargins: 6
    }
    Loader {
        id:loader
    }
    Component{
        id:com_screen
        Window{
            property bool isZeroPos: screenshot.start === Qt.point(0,0) && screenshot.end === Qt.point(0,0)
            id:window_screen
            flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
            x:-1
            y:-1
            width: 1
            height: 1
            visible: true
            color: "#00000000"
            onVisibleChanged: {
                if(!window_screen.visible){
                    loader.sourceComponent = undefined
                }
            }
            Component.onCompleted: {
                setGeometry(0,0,screenshot_background.width,screenshot_background.height)
            }
            ScreenshotBackground{
                id:screenshot_background
                captureMode:control.captrueMode
                saveFolder: {
                    if(typeof control.saveFolder === 'string'){
                        return control.saveFolder
                    }else{
                        return FluTools.toLocalPath(control.saveFolder)
                    }
                }
                onCaptrueToPixmapCompleted:
                    (captrue)=>{
                        control.captrueCompleted(captrue)
                        loader.sourceComponent = undefined
                    }
                onCaptrueToFileCompleted:
                    (captrue)=>{
                        control.captrueCompleted(captrue)
                        loader.sourceComponent = undefined
                    }
            }
            Screenshot{
                id:screenshot
                anchors.fill: parent
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton |  Qt.LeftButton
                onPressed:
                    (mouse)=>{
                        if(mouse.button === Qt.LeftButton){
                            d.enablePosition = true
                            screenshot.start = Qt.point(mouse.x,mouse.y)
                            screenshot.end = Qt.point(mouse.x,mouse.y)
                        }
                    }
                onPositionChanged:
                    (mouse)=>{
                        if(d.enablePosition){
                            screenshot.end = Qt.point(mouse.x,mouse.y)
                        }
                    }
                onReleased:
                    (mouse)=>{
                        if(mouse.button === Qt.LeftButton){
                            d.enablePosition = false
                            screenshot.end = Qt.point(mouse.x,mouse.y)
                        }
                    }
                onCanceled:
                    (mouse)=>{
                        if(mouse.button === Qt.LeftButton){
                            d.enablePosition = false
                            screenshot.end = Qt.point(mouse.x,mouse.y)
                        }
                    }
                onClicked:
                    (mouse)=>{
                        if (mouse.button === Qt.RightButton){
                            if(isZeroPos){
                                loader.sourceComponent = undefined
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
                border.width: control.borderSize
                border.color: control.borderColor
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
            Rectangle{
                id:rect_top_left
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    left: rect_capture.left
                    leftMargin: d.dotMargins
                    topMargin: d.dotMargins
                    top: rect_capture.top
                }
            }
            MouseArea{
                cursorShape: Qt.SizeFDiagCursor
                anchors.centerIn: rect_top_left
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        FluTools.setOverrideCursor(cursorShape)
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x+w,y+h)
                        screenshot.end = Qt.point(x,y)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        screenshot.end = mapToItem(screenshot,Qt.point(mouse.x,mouse.y))
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Rectangle{
                id:rect_top_center
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    horizontalCenter: rect_capture.horizontalCenter
                    topMargin: d.dotMargins
                    top: rect_capture.top
                }
            }
            MouseArea{
                cursorShape: Qt.SizeVerCursor
                anchors.centerIn: rect_top_center
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        FluTools.setOverrideCursor(cursorShape)
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x+w,y+h)
                        screenshot.end = Qt.point(x,y)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        var x = rect_capture.x
                        screenshot.end = Qt.point(x,mapToItem(screenshot,Qt.point(mouse.x,mouse.y)).y)
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Rectangle{
                id:rect_top_right
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    right: rect_capture.right
                    rightMargin: d.dotMargins
                    topMargin: d.dotMargins
                    top: rect_capture.top
                }
            }
            MouseArea{
                cursorShape: Qt.SizeBDiagCursor
                anchors.centerIn: rect_top_right
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x,y+h)
                        screenshot.end = Qt.point(x+w,y)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        screenshot.end = mapToItem(screenshot,Qt.point(mouse.x,mouse.y))
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Rectangle{
                id:rect_right_center
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    right: rect_capture.right
                    rightMargin: d.dotMargins
                    verticalCenter: rect_capture.verticalCenter
                }
            }
            MouseArea{
                cursorShape: Qt.SizeHorCursor
                anchors.centerIn: rect_right_center
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x,y)
                        screenshot.end = Qt.point(x+w,y+h)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        var y = rect_capture.y
                        var h = rect_capture.height
                        screenshot.end = Qt.point(mapToItem(screenshot,Qt.point(mouse.x,mouse.y)).x,y+h)
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Rectangle{
                id:rect_right_bottom
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    right: rect_capture.right
                    rightMargin: d.dotMargins
                    bottom: rect_capture.bottom
                    bottomMargin: d.dotMargins
                }
            }
            MouseArea{
                cursorShape: Qt.SizeFDiagCursor
                anchors.centerIn: rect_right_bottom
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x,y)
                        screenshot.end = Qt.point(x+w,y+h)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        screenshot.end = mapToItem(screenshot,Qt.point(mouse.x,mouse.y))
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Rectangle{
                id:rect_bottom_center
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    horizontalCenter: rect_capture.horizontalCenter
                    bottom: rect_capture.bottom
                    bottomMargin: d.dotMargins
                }
            }
            MouseArea{
                cursorShape: Qt.SizeVerCursor
                anchors.centerIn: rect_bottom_center
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x,y)
                        screenshot.end = Qt.point(x+w,y+h)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        var x = rect_capture.x
                        var w = rect_capture.width
                        screenshot.end = Qt.point(x+w,mapToItem(screenshot,Qt.point(mouse.x,mouse.y)).y)
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Rectangle{
                id:rect_bottom_left
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    left: rect_capture.left
                    leftMargin: d.dotMargins
                    bottom: rect_capture.bottom
                    bottomMargin: d.dotMargins
                }
            }
            MouseArea{
                cursorShape: Qt.SizeBDiagCursor
                anchors.centerIn: rect_bottom_left
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x+w,y)
                        screenshot.end = Qt.point(x,y+h)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        screenshot.end = mapToItem(screenshot,Qt.point(mouse.x,mouse.y))
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Rectangle{
                id:rect_left_center
                width: control.dotSize
                height: control.dotSize
                color: control.borderColor
                visible: !isZeroPos
                anchors{
                    left: rect_capture.left
                    leftMargin: d.dotMargins
                    verticalCenter: rect_capture.verticalCenter
                }
            }
            MouseArea{
                cursorShape: Qt.SizeHorCursor
                anchors.centerIn: rect_left_center
                width: d.dotMouseSize
                height: d.dotMouseSize
                visible: !isZeroPos
                onPressed:
                    (mouse)=> {
                        var x = rect_capture.x
                        var y = rect_capture.y
                        var w = rect_capture.width
                        var h = rect_capture.height
                        screenshot.start = Qt.point(x+w,y)
                        screenshot.end = Qt.point(x,y+h)
                    }
                onReleased:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
                onPositionChanged:
                    (mouse)=> {
                        var y = rect_capture.y
                        var h = rect_capture.height
                        screenshot.end = Qt.point(mapToItem(screenshot,Qt.point(mouse.x,mouse.y)).x,y+h)
                    }
                onCanceled:
                    (mouse)=> {
                        FluTools.restoreOverrideCursor()
                    }
            }
            Pane{
                width: 100
                height: 40
                visible: {
                    if(screenshot.start === Qt.point(0,0) && screenshot.end === Qt.point(0,0)){
                        return false
                    }
                    if(d.enablePosition){
                        return false
                    }
                    return true
                }
                x:rect_capture.x + rect_capture.width - width
                y:{
                    if(rect_capture.y + rect_capture.height + d.menuMargins < screenshot.height-height){
                        return rect_capture.y + rect_capture.height + d.menuMargins
                    }else if(rect_capture.y - height - d.menuMargins > 0){
                        return rect_capture.y - height - d.menuMargins
                    }else{
                        screenshot.height - height - d.menuMargins
                    }
                }
                RowLayout{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    FluIconButton{
                        iconSource: FluentIcons.Cancel
                        iconSize: 18
                        iconColor: Qt.rgba(247/255,75/255,77/255,1)
                        onClicked: {
                            loader.sourceComponent = undefined
                        }
                    }
                    FluIconButton{
                        iconSource: FluentIcons.AcceptMedium
                        iconColor: FluTheme.primaryColor.dark
                        onClicked: {
                            screenshot_background.capture(screenshot.start,screenshot.end)
                        }
                    }
                }
            }
        }
    }


    function open(){
        loader.sourceComponent = com_screen
    }
}
