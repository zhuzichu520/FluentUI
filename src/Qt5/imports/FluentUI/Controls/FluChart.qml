import QtQuick 2.15
import QtQuick.Window 2.15
import "./../JS/Chart.js" as Chart

Canvas {
    id: control
    property string chartType
    property var chartData
    property var chartOptions
    property double chartAnimationProgress: 0.1
    property int animationEasingType: Easing.InOutExpo
    property double animationDuration: 300
    property alias animationRunning: chartAnimator.running
    signal animationFinished()
    function animateToNewData()
    {
        chartAnimationProgress = 0.1;
        if (d.jsChart) {
            d.jsChart.update();
        }
        chartAnimator.restart();
    }
    QtObject{
        id:d
        property var jsChart: undefined
        property var memorizedContext
        property var memorizedData
        property var memorizedOptions
    }
    MouseArea {
        id: event
        anchors.fill: control
        hoverEnabled: true
        enabled: true
        property var handler: undefined
        property QtObject mouseEvent: QtObject {
            property int left: 0
            property int top: 0
            property int x: 0
            property int y: 0
            property int clientX: 0
            property int clientY: 0
            property string type: ""
            property var target
        }
        function submitEvent(mouse, type) {
            mouseEvent.type = type
            mouseEvent.clientX = mouse ? mouse.x : 0;
            mouseEvent.clientY = mouse ? mouse.y : 0;
            mouseEvent.x = mouse ? mouse.x : 0;
            mouseEvent.y = mouse ? mouse.y : 0;
            mouseEvent.left = 0;
            mouseEvent.top = 0;
            mouseEvent.target = control;
            if(handler) {
                handler(mouseEvent);
            }
            control.requestPaint();
        }
        onClicked:
            (mouse)=> {
                submitEvent(mouse, "click");
            }
        onPositionChanged:
            (mouse)=> {
                submitEvent(mouse, "mousemove");
            }
        onExited: {
            submitEvent(undefined, "mouseout");
        }
        onEntered: {
            submitEvent(undefined, "mouseenter");
        }
        onPressed:
            (mouse)=> {
                submitEvent(mouse, "mousedown");
            }
        onReleased:
            (mouse)=> {
                submitEvent(mouse, "mouseup");
            }
    }
    PropertyAnimation {
        id: chartAnimator
        target: control
        property: "chartAnimationProgress"
        alwaysRunToEnd: true
        to: 1
        duration: control.animationDuration
        easing.type: control.animationEasingType
        onFinished: {
            control.animationFinished();
        }
    }
    onChartAnimationProgressChanged: {
        control.requestPaint();
    }
    onPaint: {
        if(control.getContext('2d') !== null && d.memorizedContext !== control.getContext('2d') || d.memorizedData !== control.chartData || d.memorizedOptions !== control.chartOptions) {
            var ctx = control.getContext('2d');
            d.jsChart =  Chart.build(ctx, {type: control.chartType,data: control.chartData,options: control.chartOptions});
            d.memorizedData = control.chartData ;
            d.memorizedContext = control.getContext('2d');
            d.memorizedOptions = control.chartOptions;
            d.jsChart.bindEvents(function(newHandler) {event.handler = newHandler;});
            chartAnimator.start();
        }
        d.jsChart.draw(chartAnimationProgress);
    }
    onWidthChanged: {
        if(d.jsChart) {
            d.jsChart.resize();
        }
    }
    onHeightChanged: {
        if(d.jsChart) {
            d.jsChart.resize();
        }
    }
}
