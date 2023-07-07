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
    property Component loadingItem : com_loading
    property Component emptyItem : com_empty
    property Component errorItem : com_error

    Item{
        id:container
        anchors.fill: parent
        visible: statusMode===FluStatusView.Success
    }
    Loader{
        id:loader
        anchors.fill: parent
        visible: statusMode!==FluStatusView.Success
        sourceComponent: {
            if(statusMode === FluStatusView.Loading){
                return loadingItem
            }
            if(statusMode === FluStatusView.Empty){
                return emptyItem
            }
            if(statusMode === FluStatusView.Error){
                return errorItem
            }
            return undefined
        }
    }
    Component{
        id:com_loading
        FluArea{
            paddings: 0
            border.width: 0
            radius: 0
            color:control.color
            ColumnLayout{
                anchors.centerIn: parent
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
    }
    Component {
        id:com_empty
        FluArea{
            paddings: 0
            border.width: 0
            radius: 0
            color:control.color
            ColumnLayout{
                anchors.centerIn: parent
                FluText{
                    text:control.emptyText
                    font: FluTextStyle.BodyStrong
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
    Component{
        id:com_error
        FluArea{
            paddings: 0
            border.width: 0
            radius: 0
            color:control.color
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
