import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

Popup{
    property var steps : []
    property int targetMargins: 5
    property Component nextButton: com_next_button
    property Component prevButton: com_prev_button
    property int index : 0
    property string finishText: "结束导览"
    property string nextText: "下一步"
    property string previousText: "上一步"
    id:control
    padding: 0
    parent: Overlay.overlay
    width: d.parentWidth
    height: d.parentHeight
    background: Item{}
    contentItem: Item{}
    onVisibleChanged: {
        if(visible){
            control.index = 0
        }
    }
    onIndexChanged: {
        canvas.requestPaint()
    }
    Component{
        id: com_next_button
        FluFilledButton{
            text: isEnd ? control.finishText : control.nextText
            onClicked: {
                if(isEnd){
                    control.close()
                }else{
                    control.index = control.index + 1
                }
            }
        }
    }
    Component{
        id: com_prev_button
        FluButton{
            text: control.previousText
            onClicked: {
                control.index = control.index - 1
            }
        }
    }
    Item{
        id:d
        property var window: Window.window
        property point pos: Qt.point(0,0)
        property var step: steps[index]
        property var target: {
            if(steps[index]){
                return steps[index].target()
            }
            return undefined
        }
        property int parentHeight: {
            if(control.parent){
                return control.parent.height
            }
            return control.height
        }
        property int parentWidth: {
            if(control.parent){
                return control.parent.width
            }
            return control.width
        }
    }
    Connections{
        target: d.window
        function onWidthChanged(){
            canvas.requestPaint()
            timer_delay.restart()
        }
        function onHeightChanged(){
            canvas.requestPaint()
            timer_delay.restart()
        }
    }
    Timer{
        id: timer_delay
        interval: 200
        onTriggered: {
            canvas.requestPaint()
        }
    }
    Canvas{
        id: canvas
        anchors.fill: parent
        onPaint: {
            d.pos = d.target.mapToGlobal(0,0)
            d.pos = Qt.point(d.pos.x-d.window.x,d.pos.y-d.window.y)
            var ctx = canvas.getContext("2d")
            ctx.clearRect(0, 0, canvasSize.width, canvasSize.height)
            ctx.save()
            ctx.fillStyle = "#88000000"
            ctx.fillRect(0, 0, canvasSize.width, canvasSize.height)
            ctx.globalCompositeOperation = 'destination-out'
            ctx.fillStyle = 'black'
            var rect = Qt.rect(d.pos.x-control.targetMargins,d.pos.y-control.targetMargins, d.target.width+control.targetMargins*2, d.target.height+control.targetMargins*2)
            drawRoundedRect(rect,2,ctx)
            ctx.restore()
        }
        function drawRoundedRect(rect, r, ctx) {
            ctx.beginPath();
            ctx.moveTo(rect.x + r, rect.y);
            ctx.lineTo(rect.x + rect.width - r, rect.y);
            ctx.arcTo(rect.x + rect.width, rect.y, rect.x + rect.width, rect.y + r, r);
            ctx.lineTo(rect.x + rect.width, rect.y + rect.height - r);
            ctx.arcTo(rect.x + rect.width, rect.y + rect.height, rect.x + rect.width - r, rect.y + rect.height, r);
            ctx.lineTo(rect.x + r, rect.y + rect.height);
            ctx.arcTo(rect.x, rect.y + rect.height, rect.x, rect.y + rect.height - r, r);
            ctx.lineTo(rect.x, rect.y + r);
            ctx.arcTo(rect.x, rect.y, rect.x + r, rect.y, r);
            ctx.closePath();
            ctx.fill()
        }
    }
    FluArea{
        id: layout_panne
        radius: 5
        width: 500
        height: 88 + text_desc.height
        color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
        property int dir : {
            if(y<d.pos.y)
                return 1
            return 0
        }
        x: {
            if(d.target){
                return Math.min(Math.max(0,d.pos.x+d.target.width/2-width/2),control.width-width)
            }
            return 0
        }
        y: {
            if(d.target){
                var ty=d.pos.y+d.target.height+control.targetMargins + 15
                if((ty+height)>control.height)
                    return d.pos.y-height-control.targetMargins - 15
                return ty
            }
            return 0
        }
        border.width: 0
        FluShadow{
            radius: 5
        }
        FluText{
            text: {
                if(d.step){
                    return d.step.title
                }
                return ""
            }
            font: FluTextStyle.BodyStrong
            elide: Text.ElideRight
            anchors{
                top: parent.top
                left: parent.left
                topMargin: 15
                leftMargin: 15
                right: parent.right
                rightMargin: 32
            }
        }
        FluText{
            id: text_desc
            font: FluTextStyle.Body
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 4
            elide: Text.ElideRight
            text: {
                if(d.step){
                    return d.step.description
                }
                return ""
            }
            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
                rightMargin: 15
                topMargin: 42
                leftMargin: 15
            }
        }
        FluLoader{
            id: loader_next
            property bool isEnd: control.index === steps.length-1
            sourceComponent: com_next_button
            anchors{
                top: text_desc.bottom
                topMargin: 10
                right: parent.right
                rightMargin: 15
            }
        }
        FluLoader{
            id: loader_prev
            visible: control.index !== 0
            sourceComponent: com_prev_button
            anchors{
                right: loader_next.left
                top: loader_next.top
                rightMargin: 14
            }
        }
        FluIconButton{
            anchors{
                right: parent.right
                top: parent.top
                margins: 10
            }
            width: 26
            height: 26
            verticalPadding: 0
            horizontalPadding: 0
            iconSize: 12
            iconSource: FluentIcons.ChromeClose
            onClicked: {
                control.close()
            }
        }
    }
    FluIcon{
        iconSource: layout_panne.dir?FluentIcons.FlickUp:FluentIcons.FlickDown
        color: layout_panne.color
        x: {
            if(d.target){
                return d.pos.x+d.target.width/2-10
            }
            return 0
        }
        y: {
            if(d.target){
                return d.pos.y+(layout_panne.dir?-height:d.target.height)
            }
            return 0
        }
    }
}
