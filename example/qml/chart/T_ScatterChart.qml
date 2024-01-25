import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title:"Scatter Chart"

    function randomScalingFactor() {
        return Math.random().toFixed(1);
    }

    FluArea{
        height: 370
        width: 500
        paddings: 10
        Layout.topMargin: 20
        FluChart{
            anchors.fill: parent
            chartType: 'scatter'
            chartData: {
                return {
                    datasets: [{
                            label: 'My First dataset',
                            xAxisID: 'x-axis-1',
                            yAxisID: 'y-axis-1',
                            borderColor: '#ff5555',
                            backgroundColor: 'rgba(255,192,192,0.3)',
                            data: [{
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }]
                        }, {
                            label: 'My Second dataset',
                            xAxisID: 'x-axis-1',
                            yAxisID: 'y-axis-2',
                            borderColor: '#5555ff',
                            backgroundColor: 'rgba(192,192,255,0.3)',
                            data: [{
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }, {
                                    x: randomScalingFactor(),
                                    y: randomScalingFactor(),
                                }]
                        }]
                }}
            chartOptions: {return {
                    maintainAspectRatio: false,
                    responsive: true,
                    hoverMode: 'nearest',
                    intersect: true,
                    title: {
                        display: true,
                        text: 'Chart.js Scatter Chart - Multi Axis'
                    },
                    scales: {
                        xAxes: [{
                                position: 'bottom',
                                gridLines: {
                                    zeroLineColor: 'rgba(0,0,0,1)'
                                }
                            }],
                        yAxes: [{
                                type: 'linear', // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
                                display: true,
                                position: 'left',
                                id: 'y-axis-1',
                            }, {
                                type: 'linear', // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
                                display: true,
                                position: 'right',
                                reverse: true,
                                id: 'y-axis-2',

                                // grid line settings
                                gridLines: {
                                    drawOnChartArea: false, // only want the grid lines for one axis to show up
                                },
                            }],
                    }
                }
            }
        }
    }

}
