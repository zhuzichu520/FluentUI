import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import example 1.0
import "../component"

FluPage{
    title: qsTr("QCustomPlot2")
    RealTimePlot {
        anchors.fill: parent          // 关键：给容器确定尺寸

        id: realtimePlot
        xAxis.visible: true
        yAxis.visible: true

        xAxis.ticker.tickCount: 2
        xAxis.ticker.ticks: true
        xAxis.ticker.subTicks: false
        yAxis.ticker.tickCount: 10
        yAxis.ticker.ticks: true
        yAxis.ticker.subTicks: false

        backgroundColor: FluTheme.dark ? Qt.rgba(39/255, 39/255, 39/255, 1) : "white"
        baseColor: FluTheme.dark ? "white" : Qt.rgba(39/255, 39/255, 39/255, 1)
        labelColor: FluTheme.dark ? "white" : Qt.rgba(39/255, 39/255, 39/255, 1)
        maxBufferPoints: 20000
        refreshMs: 30
        initialXRange : ({"lower":0, "upper":1.0})
        initialYRange : ({"lower":-2, "upper":2})
        Component.onCompleted: {
            realtimePlot.addGraph("main");
        }

        Component.onDestruction: {

        }
        // 鼠标滚轮缩放
        MouseArea {
            id: rtMouse
            anchors.fill: parent
            hoverEnabled: true
            property double posX : 0
            property double posY : 0
            // 框选缩放相关
            property bool dragging: false
            property real startX: 0
            property real startY: 0
            property real curX: 0
            property real curY: 0

            onPositionChanged: function(mouse) {
                // console.log("mouse:", mouse.x, mouse.y)
                posX = mouse.x
                posY = mouse.y
                if (dragging) {
                    curX = mouse.x
                    curY = mouse.y
                }
            }
            onPressed: function(mouse) {
                if (mouse.button === Qt.LeftButton) {
                    dragging = true
                    startX = mouse.x
                    startY = mouse.y
                    curX = mouse.x
                    curY = mouse.y
                }
            }
            onReleased: function(mouse) {
                if (dragging && mouse.button === Qt.LeftButton) {
                    dragging = false
                    // 计算选择框
                    var x1 = Math.min(startX, curX)
                    var y1 = Math.min(startY, curY)
                    var x2 = Math.max(startX, curX)
                    var y2 = Math.max(startY, curY)
                    var selW = Math.abs(x2 - x1)
                    var selH = Math.abs(y2 - y1)
                    // 阈值，避免误触
                    if (selW > 8 && selH > 8) {
                        // 将像素坐标转换为数据坐标
                        realtimePlot.setRangeByPixels(x1, y1, x2, y2)
                    }
                }
            }
            onWheel: function(wheel){
                let delta = wheel.angleDelta.y;
                if (wheel.modifiers & Qt.ControlModifier) {
                    realtimePlot.zoomXY(posX, posY, delta > 0 ? 0.9 : 1.1, true);
                } else {
                    realtimePlot.moveY( delta > 0 ? -0.05 : 0.05);
                }
                wheel.accepted = true;
            }
            onDoubleClicked: function(mouse) {
                if (mouse.button === Qt.LeftButton) {
                    realtimePlot.resetRange();
                }
            }
        }
        // 框选可视化选区
        Rectangle {
            id: realtimeSelection
            x: Math.min(rtMouse.startX, rtMouse.curX)
            y: Math.min(rtMouse.startY, rtMouse.curY)
            width: Math.abs(rtMouse.curX - rtMouse.startX)
            height: Math.abs(rtMouse.curY - rtMouse.startY)
            visible: rtMouse.dragging && width > 4 && height > 4
            color: Qt.rgba(0, 120/255, 215/255, 0.15) // Windows 风格选区蓝
            border.color: Qt.rgba(0, 120/255, 215/255, 0.8)
            border.width: 1
            z: 10
        }
    }

    DataGenerator {
        id: dataGenerator
        Component.onCompleted: {
            dataGenerator.start();
        }
    }

    // 使用数据的示例
    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            // 获取最新数据
            var xData = dataGenerator.xData
            var yData = dataGenerator.yData
            realtimePlot.appendBatch(xData, yData);
        }
    }
}
