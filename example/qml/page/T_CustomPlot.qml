import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluPage{

    title: qsTr("QCustomPlot")
    TimePlot {
        id: timePlot
        anchors.fill: parent
        plotTimeRangeInMilliseconds: 10
        xAxis.visible: true
        yAxis.visible: true
        x1Axis.visible: false
        y1Axis.visible: false
        yAxis.ticker.tickCount: 6
        yAxis.ticker.ticks: false
        yAxis.ticker.subTicks: false
        yAxis.ticker.baseColor: "transparent"
        yAxis.grid.lineColor: "mediumaquamarine"
        xAxis.ticker.baseColor: "midnightblue"
        xAxis.ticker.baseWidth: 2
        xAxis.grid.lineColor: "transparent"
        backgroundColor: "mistyrose"
        Component.onCompleted: {
            yAxis.setRange(0, 100)
            addGraph("1")
            graphs["1"].graphColor = "slategrey"
        }
    }
    Timer {
        running: true
        repeat: true
        interval: 20
        property int data: 60
        onTriggered: {
            data = data - 1
            if(data == 20) {
                data = 60
            }
            timePlot.addCurrentTimeValue("1", data)
        }
    }


}
