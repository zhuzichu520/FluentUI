import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item{
    id:control
    default property alias content: container.data
    property int statusMode: FluStatusLayoutType.Loading
    property string loadingText: qsTr("Loading...")
    property string emptyText: qsTr("Empty")
    property string errorText: qsTr("Error")
    property string errorButtonText: qsTr("Reload")
    property color color: Qt.rgba(0,0,0,0)
    signal errorClicked
    property Component loadingItem : com_loading
    property Component emptyItem : com_empty
    property Component errorItem : com_error

    Item{
        id:container
        anchors.fill: parent
        visible: statusMode===FluStatusLayoutType.Success
    }
    FluLoader{
        id:loader
        anchors.fill: parent
        visible: statusMode!==FluStatusLayoutType.Success
        sourceComponent: {
            if(statusMode === FluStatusLayoutType.Loading){
                return loadingItem
            }
            if(statusMode === FluStatusLayoutType.Empty){
                return emptyItem
            }
            if(statusMode === FluStatusLayoutType.Error){
                return errorItem
            }
            return undefined
        }
    }
    Component{
        id:com_loading
        FluFrame{
            padding: 0
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
        FluFrame{
            padding: 0
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
        FluFrame{
            padding: 0
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
        statusMode = FluStatusLayoutType.Success
    }
    function showLoadingView(){
        statusMode = FluStatusLayoutType.Loading
    }
    function showEmptyView(){
        statusMode = FluStatusLayoutType.Empty
    }
    function showErrorView(){
        statusMode = FluStatusLayoutType.Error
    }
}
