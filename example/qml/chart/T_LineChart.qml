import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    id: root
    title: qsTr("Line Chart")
    property var data : []

    FluFrame{
        Layout.preferredWidth: 500
        Layout.preferredHeight: 370
        padding: 10
        Layout.topMargin: 20
        FluChart{
            id: chart
            anchors.fill: parent
            chartType: 'line'
            chartData: { return {
                    labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                    datasets: [{
                            label: 'My First Dataset',
                            data: root.data,
                            fill: false,
                            borderColor: 'rgb(75, 192, 192)',
                            tension: 0.1
                        }]
                }
            }
            chartOptions: { return {
                    maintainAspectRatio: false,
                    title: {
                        display: true,
                        text: 'Chart.js Line Chart - Stacked'
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: false
                    }
                }
            }
        }
        Timer{
            id: timer
            interval: 300
            repeat: true
            onTriggered: {
                root.data.push(Math.random()*100)
                if(root.data.length>7){
                    root.data.shift()
                }
                chart.animateToNewData()
            }
        }
        Component.onCompleted: {
            timer.restart()
        }
    }
}
