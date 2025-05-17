import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

Popup{
    property var steps : []
    property int targetMargins: 5
    property int targetRadius: 2
    property Component nextButton: com_next_button
    property Component prevButton: com_prev_button
    property Component indicator: com_indicator
    property int index : 0
    property string finishText: qsTr("Finish")
    property string nextText: qsTr("Next")
    property string previousText: qsTr("Previous")
    id:control
    padding: 0
    parent: Overlay.overlay
    width: d.parentWidth
    height: d.parentHeight
    background: Item{}
    contentItem: Item{}
    onVisibleChanged: {
        if(visible){
            d.animationEnabled = false
            control.index = 0
            d.updatePos()
            d.animationEnabled = true
        }
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
    Component{
        id: com_indicator
        Row{
            spacing: 10
            Repeater{
                model: total
                delegate: Rectangle{
                    width: 8
                    height: 8
                    radius: 4
                    scale: current === index ? 1.2 : 1
                    color:{
                        if(current === index){
                            return FluTheme.primaryColor
                        }
                        return FluTheme.dark ? Qt.rgba(99/255,99/255,99/255,1) : Qt.rgba(214/255,214/255,214/255,1)
                    }
                }
            }
        }
    }
    Item{
        id:d
        property var window: Window.window
        property point pos: Qt.point(0,0)
        property bool animationEnabled: true
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
        function updatePos(){
            if(d.target && d.window){
                d.pos = d.target.mapToGlobal(0,0)
                d.pos = Qt.point(d.pos.x-d.window.x,d.pos.y-d.window.y)
            }
        }
        onTargetChanged: {
            updatePos()
        }
    }
    Connections{
        target: d.window
        function onWidthChanged(){
            timer_delay.restart()
        }
        function onHeightChanged(){
            timer_delay.restart()
        }
    }
    Timer{
        id: timer_delay
        interval: 200
        onTriggered: {
            d.updatePos()
        }
    }
    Item{
        id: targetRect
        x: d.pos.x - control.targetMargins
        y: d.pos.y - control.targetMargins
        width: d.target ? d.target.width + control.targetMargins * 2 : 0
        height: d.target ? d.target.height + control.targetMargins * 2 : 0
        Behavior on x {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
        Behavior on y {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
        Behavior on width {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
        Behavior on height {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
    }
    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4
        layer.smooth: true
        ShapePath {
            fillColor: "#88000000"
            strokeWidth: 0
            strokeColor: "transparent"

            // draw background
            PathMove {
                x: 0
                y: 0
            }
            PathLine {
                x: control.width
                y: 0
            }
            PathLine {
                x: control.width
                y: control.height
            }
            PathLine {
                x: 0
                y: control.height
            }
            PathLine {
                x: 0
                y: 0
            }

            // draw highlight
            PathMove {
                x: targetRect.x + control.targetRadius
                y: targetRect.y
            }
            PathLine {
                x: targetRect.x + targetRect.width - control.targetRadius
                y: targetRect.y
            }
            PathArc {
                x: targetRect.x + targetRect.width
                y: targetRect.y + control.targetRadius
                radiusX: control.targetRadius
                radiusY: control.targetRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }

            PathLine {
                x: targetRect.x + targetRect.width
                y: targetRect.y + targetRect.height - control.targetRadius
            }
            PathArc {
                x: targetRect.x + targetRect.width - control.targetRadius
                y: targetRect.y + targetRect.height
                radiusX: control.targetRadius
                radiusY: control.targetRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }

            PathLine {
                x: targetRect.x + control.targetRadius
                y: targetRect.y + targetRect.height
            }
            PathArc {
                x: targetRect.x
                y: targetRect.y + targetRect.height - control.targetRadius
                radiusX: control.targetRadius
                radiusY: control.targetRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }

            PathLine {
                x: targetRect.x
                y: targetRect.y + control.targetRadius
            }
            PathArc {
                x: targetRect.x + control.targetRadius
                y: targetRect.y
                radiusX: control.targetRadius
                radiusY: control.targetRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }
        }
    }
    FluFrame{
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
        Behavior on x {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
        Behavior on y {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
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
            wrapMode: Text.WordWrap
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
            readonly property int total: steps.length
            readonly property int current: control.index
            sourceComponent: control.indicator
            anchors{
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 15
                leftMargin: 15
            }
        }
        FluLoader{
            id: loader_next
            property bool isEnd: control.index === steps.length-1
            sourceComponent: control.nextButton
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
            sourceComponent: control.prevButton
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
        Behavior on x {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
        Behavior on y {
            enabled: d.animationEnabled && FluTheme.animationEnabled
            NumberAnimation {
                duration: 167
            }
        }
    }
}
