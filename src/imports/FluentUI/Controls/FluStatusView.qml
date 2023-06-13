import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Item{
    id:control
    enum StatusMode  {
        Loading,
        Empty,
        Error,
        Success
    }
    default property alias content: container.data
    property int statusMode: FluStatusView.Loading
    property string loadingText:"正在加载..."
    property string emptyText: "空空如也"
    property string errorText: "页面出错了.."
    property string errorButtonText: "重新加载"
    property color color: FluTheme.dark ? Window.active ?  Qt.rgba(38/255,44/255,54/255,1) : Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    signal errorClicked
    Item{
        id:container
        anchors.fill: parent
        visible: statusMode === FluStatusView.Success
    }
    FluArea{
        paddings: 0
        border.width: 0
        anchors.fill: container
        visible: opacity
        opacity: statusMode === FluStatusView.Loading
        Behavior on opacity {
            NumberAnimation  { duration: 83 }
        }
        color:control.color
        ColumnLayout{
            anchors.centerIn: parent
            visible: statusMode === FluStatusView.Loading
            FluProgressRing{
                indeterminate: true
                Layout.alignment: Qt.AlignHCenter
            }
            FluText{
                text:control.loadingText
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    FluArea{
        paddings: 0
        border.width: 0
        anchors.fill: container
        visible: opacity
        color:control.color
        opacity: statusMode === FluStatusView.Empty
        Behavior on opacity {
            NumberAnimation  { duration: 83 }
        }
        ColumnLayout{
            anchors.centerIn: parent
            visible: statusMode === FluStatusView.Empty
            FluText{
                text:control.emptyText
                font: FluTextStyle.BodyStrong
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    FluArea{
        paddings: 0
        border.width: 0
        anchors.fill: container
        visible: opacity
        color:control.color
        opacity: statusMode === FluStatusView.Error
        Behavior on opacity {
            NumberAnimation  { duration: 83 }
        }
        ColumnLayout{
            anchors.centerIn: parent
            FluText{
                text:control.errorText
                font: FluTextStyle.BodyStrong
                Layout.alignment: Qt.AlignHCenter
            }
            FluFilledButton{
                id:btn_error
                Layout.alignment: Qt.AlignHCenter
                text:control.errorButtonText
                onClicked:{
                    control.errorClicked()
                }
            }
        }
    }
    function showSuccessView(){
        statusMode = FluStatusView.Success
    }
    function showLoadingView(){
        statusMode = FluStatusView.Loading
    }
    function showEmptyView(){
        statusMode = FluStatusView.Empty
    }
    function showErrorView(){
        statusMode = FluStatusView.Error
    }
}
