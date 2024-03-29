import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Dialog")

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        padding: 10
        FluButton{
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Show Double Button Dialog")
            onClicked: {
                double_btn_dialog.open()
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluContentDialog{
    id:dialog
    title: qsTr("Friendly Reminder")
    message: qsTr("Are you sure you want to opt out?")
    negativeText: qsTr("Cancel")
    buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
    onNegativeClicked:{
        showSuccess(qsTr("Click the Cancel Button"))
    }
    positiveText: qsTr("OK")
    onPositiveClicked:{
        showSuccess(qsTr("Click the OK Button"))
        }
    }
    dialog.open()'
    }

    FluContentDialog{
        id:double_btn_dialog
        title: qsTr("Friendly Reminder")
        message: qsTr("Are you sure you want to opt out?")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: qsTr("Cancel")
        onNegativeClicked: {
            showSuccess(qsTr("Click the Cancel Button"))
        }
        positiveText: qsTr("OK")
        onPositiveClicked:{
            showSuccess(qsTr("Click the OK Button"))
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        padding: 10
        Layout.topMargin: 20
        FluButton{
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Show Triple Button Dialog")
            onClicked: {
                triple_btn_dialog.open()
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluContentDialog{
    id: dialog
    title: qsTr("Friendly Reminder")
    message: qsTr("Are you sure you want to opt out?")
    negativeText: qsTr("Cancel")
    buttonFlags: FluContentDialogType.NeutralButton | FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
    negativeText: qsTr("Cancel")
    onNegativeClicked: {
        showSuccess(qsTr("Click the Cancel Button"))
    }
    positiveText: qsTr("OK")
    onPositiveClicked: {
        showSuccess(qsTr("Click the OK Button"))
    }
    neutralText: qsTr("Minimize")
    onNeutralClicked: {
        showSuccess(qsTr("Click Minimize"))
        }
    }
    dialog.open()'
    }

    FluContentDialog{
        id: triple_btn_dialog
        title: qsTr("Friendly Reminder")
        message: qsTr("Are you sure you want to opt out?")
        buttonFlags: FluContentDialogType.NeutralButton | FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: qsTr("Cancel")
        onNegativeClicked: {
            showSuccess(qsTr("Click the Cancel Button"))
        }
        positiveText: qsTr("OK")
        onPositiveClicked: {
            showSuccess(qsTr("Click the OK Button"))
        }
        neutralText: qsTr("Minimize")
        onNeutralClicked: {
            showSuccess(qsTr("Click Minimize"))
        }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        FluButton{
            anchors.top: parent.top
            anchors.topMargin: 5
            text: qsTr("Custom Content Dialog")
            onClicked: {
                custom_btn_dialog.open()
            }
        }
        FluButton{
            anchors.top: parent.top
            anchors.topMargin: 48
            text: qsTr("Custom Content Dialog2")
            onClicked: {
                custom_btn_dialog2.open()
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluContentDialog{
    id: dialog
    title: qsTr("Friendly Reminder")
    message: qsTr("Data is loading, please wait...")
    negativeText: qsTr("Unload")
    contentDelegate: Component{
        Item{
            width: parent.width
            height: 80
            FluProgressRing{
                anchors.centerIn: parent
            }
        }
    }
    onNegativeClicked: {
        showSuccess(qsTr("Click the Cancel Button"))
    }
    positiveText :qsTr("OK")
    onPositiveClicked: {
        showSuccess(qsTr("Click the OK Button"))
        }
    }
    dialog.open()'
    }

    FluContentDialog{
        id: custom_btn_dialog
        title: qsTr("Friendly Reminder")
        message: qsTr("Data is loading, please wait...")
        negativeText: qsTr("Unload")
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 80
                FluProgressRing{
                    anchors.centerIn: parent
                }
            }
        }
        onNegativeClicked: {
            showSuccess(qsTr("Click the Cancel Button"))
        }
        positiveText: qsTr("OK")
        onPositiveClickListener: function(){
            showError(qsTr("Test the InfoBar level on top of the Popup"))
        }
    }

    FluContentDialog{
        id:custom_btn_dialog2
        title: qsTr("Line Chart")
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 300
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
        buttonFlags: FluContentDialogType.PositiveButton
        positiveText: qsTr("OK")
        onPositiveClicked: {
            showSuccess(qsTr("Click the OK Button"))
        }
    }
}
