import QtQuick
import Qt.labs.platform
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import FluentUI
import "qrc:///example/qml/component"

FluContentPage{

    title:"Http"

    FluHttp{
        id:http
    }

    Flickable{
        id:layout_flick
        width: 160
        clip: true
        anchors{
            top: parent.top
            topMargin: 20
            bottom: parent.bottom
            left: parent.left
        }
        ScrollBar.vertical: FluScrollBar {}
        contentHeight:layout_column.height
        Column{
            spacing: 2
            id:layout_column
            width: parent.width
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Get请求"
                onClicked: {
                    var callable = {}
                    callable.onStart = function(){
                        showLoading()
                    }
                    callable.onFinish = function(){
                        hideLoading()
                    }
                    callable.onSuccess = function(result){
                        text_info.text = result
                        console.debug(result)
                    }
                    callable.onError = function(status,errorString){
                        console.debug(status+";"+errorString)
                    }
                    http.get("https://httpbingo.org/get",callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post表单请求"
                onClicked: {
                    var callable = {}
                    callable.onStart = function(){
                        showLoading()
                    }
                    callable.onFinish = function(){
                        hideLoading()
                    }
                    callable.onSuccess = function(result){
                        text_info.text = result
                        console.debug(result)
                    }
                    callable.onError = function(status,errorString){
                        console.debug(status+";"+errorString)
                    }
                    var param = {}
                    param.custname = "朱子楚"
                    param.custtel = "1234567890"
                    param.custemail = "zhuzichu520@gmail.com"
                    http.post("https://httpbingo.org/post",callable,param)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post Json请求"
                onClicked: {
                    var callable = {}
                    callable.onStart = function(){
                        showLoading()
                    }
                    callable.onFinish = function(){
                        hideLoading()
                    }
                    callable.onSuccess = function(result){
                        text_info.text = result
                        console.debug(result)
                    }
                    callable.onError = function(status,errorString){
                        console.debug(status+";"+errorString)
                    }
                    var param = {}
                    param.custname = "朱子楚"
                    param.custtel = "1234567890"
                    param.custemail = "zhuzichu520@gmail.com"
//                    http.postJson("https://httpbingo.org/post",callable,param)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post String请求"
                onClicked: {
                    var callable = {}
                    callable.onStart = function(){
                        showLoading()
                    }
                    callable.onFinish = function(){
                        hideLoading()
                    }
                    callable.onSuccess = function(result){
                        text_info.text = result
                        console.debug(result)
                    }
                    callable.onError = function(status,errorString){
                        console.debug(status+";"+errorString)
                    }
                    var param = "我命由我不由天"
//                    http.postString("https://httpbingo.org/post",callable,param)
                }
            }
            FluButton{
                id:btn_download
                implicitWidth: parent.width
                implicitHeight: 36
                text: "下载文件"
                onClicked: {
                    file_dialog.open()
                }
            }
        }
    }

    FolderDialog {
        id: file_dialog
        currentFolder: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
        onAccepted: {
            var callable = {}
            callable.onStart = function(){
                btn_download.disabled = true
            }
            callable.onFinish = function(){
                btn_download.disabled = false
                btn_download.text = "下载文件"
                layout_file_size.visible = false
                text_file_size.text = ""
            }
            callable.onSuccess = function(result){
                showSuccess(result)
            }
            callable.onError = function(status,errorString){
                showError(errorString)
            }
            callable.onDownloadProgress = function(recv,total){
                var locale = Qt.locale()
                var precent = (recv/total * 100).toFixed(0) + "%"
                btn_download.text = "下载中..."+precent
                text_file_size.text =  "%1/%2".arg(locale.formattedDataSize(recv)).arg(locale.formattedDataSize(total))
                layout_file_size.visible = true
            }
            var path = FluTools.toLocalPath(currentFolder)+ "/big_buck_bunny.mp4"
            http.download("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",callable,path)
        }
    }

    FluArea{
        anchors{
            top: layout_flick.top
            bottom: layout_flick.bottom
            left: layout_flick.right
            right: parent.right
            leftMargin: 8
        }
        Flickable{
            clip: true
            id:scrollview
            width: parent.width
            height: parent.height
            contentWidth: width
            contentHeight: text_info.height
            ScrollBar.vertical: FluScrollBar {}
            FluText{
                id:text_info
                width: scrollview.width
                wrapMode: Text.WrapAnywhere
                padding: 14
            }
        }
    }

    FluRectangle{
        id:layout_file_size
        radius: [4,4,4,4]
        height: 36
        width: 160
        visible: false
        x:layout_flick.width
        y: 173 - layout_flick.contentY
        FluText{
            id:text_file_size
            anchors.centerIn: parent
        }
    }

}
