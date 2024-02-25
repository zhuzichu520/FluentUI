import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title:"Dialog"

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
        FluButton{
            anchors.verticalCenter: parent.verticalCenter
            text:"Show Double Button Dialog"
            onClicked: {
                double_btn_dialog.open()
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluContentDialog{
    id:dialog
    title:"友情提示"
    message:"确定要退出程序么？"
    negativeText:"取消"
    buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
    onNegativeClicked:{
        showSuccess("点击取消按钮")
    }
    positiveText:"确定"
    onPositiveClicked:{
        showSuccess("点击确定按钮")
        }
    }
    dialog.open()'
    }

    FluContentDialog{
        id:double_btn_dialog
        title:"友情提示"
        message:"确定要退出程序么？"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText:"取消"
        onNegativeClicked:{
            showSuccess("点击取消按钮")
        }
        positiveText:"确定"
        onPositiveClicked:{
            showSuccess("点击确定按钮")
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
        FluButton{
            anchors.verticalCenter: parent.verticalCenter
            text:"Show Triple Button Dialog"
            onClicked: {
                triple_btn_dialog.open()
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluContentDialog{
    id:dialog
    title:"友情提示"
    message:"确定要退出程序么？"
    negativeText:"取消"
    buttonFlags: FluContentDialogType.NeutralButton | FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
    negativeText:"取消"
    onNegativeClicked:{
        showSuccess("点击取消按钮")
    }
    positiveText:"确定"
    onPositiveClicked:{
        showSuccess("点击确定按钮")
    }
    neutralText:"最小化"
    onNeutralClicked:{
        showSuccess("点击最小化按钮")
        }
    }
    dialog.open()'
    }

    FluContentDialog{
        id:triple_btn_dialog
        title:"友情提示"
        message:"确定要退出程序么？"
        buttonFlags: FluContentDialogType.NeutralButton | FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText:"取消"
        onNegativeClicked:{
            showSuccess("点击取消按钮")
        }
        positiveText:"确定"
        onPositiveClicked:{
            showSuccess("点击确定按钮")
        }
        neutralText:"最小化"
        onNeutralClicked:{
            showSuccess("点击最小化按钮")
        }
    }

    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20
        FluButton{
            anchors.top: parent.top
            anchors.topMargin: 5
            text:"Custom Content Dialog"
            onClicked: {
                custom_btn_dialog.open()
            }
        }
        FluButton{
            anchors.top: parent.top
            anchors.topMargin: 48
            text:"Custom Content Dialog2"
            onClicked: {
                custom_btn_dialog2.open()
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluContentDialog{
    id:dialog
    title:"友情提示"
    message:"数据正在加载中，请稍等..."
    negativeText:"取消加载"
    contentDelegate: Component{
        Item{
            width: parent.width
            height: 80
            FluProgressRing{
                anchors.centerIn: parent
            }
        }
    }
    onNegativeClicked:{
        showSuccess("点击取消按钮")
    }
    positiveText:"确定"
    onPositiveClicked:{
        showSuccess("点击确定按钮")
        }
    }
    dialog.open()'
    }

    FluContentDialog{
        id:custom_btn_dialog
        title:"友情提示"
        message:"数据正在加载中，请稍等..."
        negativeText:"取消加载"
        contentDelegate: Component{
            Item{
                implicitWidth: parent.width
                implicitHeight: 80
                FluProgressRing{
                    anchors.centerIn: parent
                }
            }
        }
        onNegativeClicked:{
            showSuccess("点击取消按钮")
        }
        positiveText:"确定"
        onPositiveClicked:{
            showSuccess("点击确定按钮")
        }
    }

    FluContentDialog{
        id:custom_btn_dialog2
        title:"折线图"
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
        positiveText:"确定"
        onPositiveClicked:{
            showSuccess("点击确定按钮")
        }
    }
}
