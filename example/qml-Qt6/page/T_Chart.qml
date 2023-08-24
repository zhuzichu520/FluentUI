import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Chart"

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

    FluArea{
        width: 500
        height: 370
        paddings: 10
        Layout.topMargin: 20
        FluChart{
            anchors.fill: parent
            chartType: 'bar'
            chartData: { return {
                    labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                    datasets: [{
                            label: 'Dataset 1',
                            backgroundColor: '#ff9999',
                            stack: 'Stack 0',
                            data: [
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor()
                            ]
                        }, {
                            label: 'Dataset 2',
                            backgroundColor: '#9999ff',
                            stack: 'Stack 0',
                            data: [
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor()
                            ]
                        }, {
                            label: 'Dataset 3',
                            backgroundColor: '#99ff99',
                            stack: 'Stack 1',
                            data: [
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor()
                            ]
                        }]
                }
            }

            chartOptions: { return {
                    maintainAspectRatio: false,
                    title: {
                        display: true,
                        text: 'Chart.js Bar Chart - Stacked'
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: false
                    },
                    responsive: true,
                    scales: {
                        xAxes: [{
                                stacked: true,
                            }],
                        yAxes: [{
                                stacked: true
                            }]
                    }
                }
            }
        }
    }

    FluArea{
        width: 500
        height: 370
        paddings: 10
        Layout.topMargin: 20
        FluChart{
            anchors.fill: parent
            chartType: 'pie'
            chartData: {return {
                    datasets: [{
                            data: [
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                            ],
                            backgroundColor: [
                                '#ffbbbb',
                                '#ffddaa',
                                '#ffffbb',
                                '#bbffbb',
                                '#bbbbff'
                            ],
                            label: 'Dataset 1'
                        }],
                    labels: [
                        'Red',
                        'Orange',
                        'Yellow',
                        'Green',
                        'Blue'
                    ]
                }}
            chartOptions: {return {maintainAspectRatio: false, responsive: true}}
        }
    }

    FluArea{
        width: 500
        height: 370
        paddings: 10
        Layout.topMargin: 20
        FluChart{
            anchors.fill: parent
            chartType: 'line'
            chartData: { return {
                    labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                    datasets: [{
                            label: 'Filled',
                            fill: true,
                            backgroundColor: 'rgba(192,222,255,0.3)',
                            borderColor: 'rgba(128,192,255,255)',
                            data: [
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor()
                            ],
                        }, {
                            label: 'Dashed',
                            fill: false,
                            backgroundColor: 'rgba(0,0,0,0)',
                            borderColor: '#009900',
                            borderDash: [5, 5],
                            data: [
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor()
                            ],
                        }, {
                            label: 'Filled',
                            backgroundColor: 'rgba(0,0,0,0)',
                            borderColor: '#990000',
                            data: [
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor(),
                                randomScalingFactor()
                            ],
                            fill: false,
                        }]
                }
            }

            chartOptions: {return {
                    maintainAspectRatio: false,
                    responsive: true,
                    title: {
                        display: true,
                        text: 'Chart.js Line Chart'
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: false,
                    },
                    hover: {
                        mode: 'nearest',
                        intersect: true
                    },
                    scales: {
                        xAxes: [{
                                display: true,
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Month'
                                }
                            }],
                        yAxes: [{
                                display: true,
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Value'
                                }
                            }]
                    }
                }
            }
        }
    }

}
