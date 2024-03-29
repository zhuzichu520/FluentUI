import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Bubble Chart")

    function randomScalingFactor() {
        return Math.random().toFixed(1);
    }

    FluArea{
        Layout.preferredWidth: 500
        Layout.preferredHeight: 370
        padding: 10
        Layout.topMargin: 20
        FluChart{
            anchors.fill: parent
            chartType: 'bubble'
            chartData: {
                return {
                    datasets: [{
                            label: 'First Dataset',
                            data: [{
                                    x: 20,
                                    y: 30,
                                    r: 15
                                }, {
                                    x: 12,
                                    y: 70,
                                    r: 20
                                }, {
                                    x: 11,
                                    y: 28,
                                    r: 8
                                }, {
                                    x: 9,
                                    y: 28,
                                    r: 10
                                }, {
                                    x: 43,
                                    y: 7,
                                    r: 14
                                }, {
                                    x: 22,
                                    y: 22,
                                    r: 12
                                }, {
                                    x: 40,
                                    y: 10,
                                    r: 10
                                }],
                            backgroundColor: 'rgb(255, 99, 132)'
                        }]
                }}
            chartOptions: {return {
                    maintainAspectRatio: false,
                    responsive: true,
                    hoverMode: 'nearest',
                    intersect: true,
                    title: {
                        display: true,
                        text: 'Chart.js Bubble Chart - Multi Axis'
                    }
                }
            }
        }
    }

}
