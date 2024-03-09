import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("Line Chart")

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
                            label: 'My First Dataset',
                            data: [65, 59, 80, 81, 56, 55, 40],
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
    }
}
