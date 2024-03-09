import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Polar Area Chart")

    FluArea{
        width: 500
        height: 370
        paddings: 10
        Layout.topMargin: 20
        FluChart{
            anchors.fill: parent
            chartType: 'polarArea'
            chartData: { return {
                    labels: [
                        'Red',
                        'Green',
                        'Yellow',
                        'Grey',
                        'Blue'
                    ],
                    datasets: [{
                            label: 'My First Dataset',
                            data: [11, 16, 7, 3, 14],
                            backgroundColor: [
                                'rgb(255, 99, 132)',
                                'rgb(75, 192, 192)',
                                'rgb(255, 205, 86)',
                                'rgb(201, 203, 207)',
                                'rgb(54, 162, 235)'
                            ]
                        }]
                }
            }

            chartOptions: { return {
                    maintainAspectRatio: false,
                    title: {
                        display: true,
                        text: 'Chart.js PolarArea Chart - Stacked'
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: false
                    }
                }
            }
        }
    }

}
