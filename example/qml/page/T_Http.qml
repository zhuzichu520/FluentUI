import QtQuick
import QtCore
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Http"


    FluHttp{
        id:http_get
        url:"https://api.github.com/search/repositories"
        onStart: {
            showLoading()
        }
        onFinish: {
            hideLoading()
        }
        onError:
            (status,errorString)=>{
                showError(errorString)
            }
        onSuccess:
            (result)=>{
                window_result.result = result
                window_result.show()
            }
    }

    FluHttp{
        id:http_post
        url:"https://www.wanandroid.com/article/query/0/json"
        onStart: {
            showLoading()
        }
        onFinish: {
            hideLoading()
        }
        onError:
            (status,errorString)=>{
                console.debug(status+"->"+errorString)
                showError(errorString)
            }
        onSuccess:
            (result)=>{
                window_result.result = result
                window_result.show()
            }
    }

    FluHttp{
        id:http_download
        url:"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        onStart: {
            btn_download.disabled = true
        }
        onFinish: {
            btn_download.disabled = false
            btn_download.text = "下载文件"
        }
        onDownloadProgress:
            (recv,total)=>{
                var precent = (recv/total * 100).toFixed(0) + "%"
                btn_download.text = "下载中..."+precent
            }
        onError:
            (status,errorString)=>{
                showError(errorString)
            }
        onSuccess:
            (result)=>{
                showSuccess(result)
            }
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 160
        paddings: 10

        ColumnLayout{
            spacing: 14
            anchors.verticalCenter: parent.verticalCenter
            FluButton{
                text:"Get请求"
                onClicked: {
                    http_get.get({q:"FluentUI"})
                }
            }
            FluButton{
                text:"Post请求"
                onClicked: {
                    http_post.post({k:"jitpack"})
                }
            }
            FluButton{
                id:btn_download
                text:disabled ? "下载中..." : "下载文件"
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
            var path = selectedFolder.toString().replace("file:///","") + "/big_buck_bunny.mp4"
            http_download.download(path)
        }
    }

    Window{
        property string result : ""
        id:window_result
        width: 600
        height: 400
        Item{
            anchors.fill: parent

            Flickable{
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
                    text:window_result.result
                    padding: 14
                }
            }
        }
    }



}
