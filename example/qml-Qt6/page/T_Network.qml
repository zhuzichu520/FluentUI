import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import Qt.labs.platform
import "qrc:///example/qml/component"

FluContentPage{

    title:"Network"

    FluNetworkCallable{
        id:callable
        onStart: {
            showLoading()
        }
        onFinish: {
            hideLoading()
        }
        onError:
            (status,errorString,result)=>{
                console.debug(status+";"+errorString+";"+result)
            }
        onCache:
            (result)=>{
                text_info.text = result
            }
        onSuccess:
            (result)=>{
                text_info.text = result
            }
    }

    Flickable{
        id:layout_flick
        width: 200
        clip: true
        anchors{
            top: parent.top
            topMargin: 20
            bottom: parent.bottom
            left: parent.left
        }
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: FluScrollBar {}
        contentHeight:layout_column.height
        Column{
            spacing: 2
            id:layout_column
            width: parent.width
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Get"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.get("https://httpbingo.org/get")
                    .addQuery("name","孙悟空")
                    .addQuery("age",500)
                    .addQuery("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post Body"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postBody("https://httpbingo.org/post")
                    .setBody("花果山水帘洞美猴王齐天大圣孙悟空")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post Form"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postForm("https://httpbingo.org/post")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post JSON"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postJson("https://httpbingo.org/post")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post JSON Array"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postJsonArray("https://httpbingo.org/post")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Put Body"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.putBody("https://httpbingo.org/put")
                    .setBody("花果山水帘洞美猴王齐天大圣孙悟空")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Put Form"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.putForm("https://httpbingo.org/put")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Put JSON"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.putJson("https://httpbingo.org/put")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Put JSON Array"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.putJsonArray("https://httpbingo.org/put")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Patch Body"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.patchBody("https://httpbingo.org/patch")
                    .setBody("花果山水帘洞美猴王齐天大圣孙悟空")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Patch Form"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.patchForm("https://httpbingo.org/patch")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Patch JSON"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.patchJson("https://httpbingo.org/patch")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Patch JSON Array"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.patchJsonArray("https://httpbingo.org/patch")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Delete Body"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.deleteBody("https://httpbingo.org/delete")
                    .setBody("花果山水帘洞美猴王齐天大圣孙悟空")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Delete Form"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.deleteForm("https://httpbingo.org/delete")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Delete JSON"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.deleteJson("https://httpbingo.org/delete")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Delete JSON Array"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.deleteJsonArray("https://httpbingo.org/delete")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Custom Header"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postJson("https://httpbingo.org/post")
                    .addHeader("os","PC")
                    .addHeader("version","1.0.0")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "RequestFailedReadCache"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postJson("https://httpbingo.org/post")
                    .setCacheMode(FluNetworkType.RequestFailedReadCache)
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .add("cacheMode","RequestFailedReadCache")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "IfNoneCacheRequest"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postJson("https://httpbingo.org/post")
                    .setCacheMode(FluNetworkType.IfNoneCacheRequest)
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .add("cacheMode","IfNoneCacheRequest")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "FirstCacheThenRequest"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postJson("https://httpbingo.org/post")
                    .setCacheMode(FluNetworkType.FirstCacheThenRequest)
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .add("cacheMode","FirstCacheThenRequest")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Timeout And Retry"
                onClicked: {
                    text_info.text = ""
                    FluNetwork.postJson("https://httpbingo.org/post")
                    .setTimeout(5000)
                    .setRetry(3)
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .add("timeout","5000")
                    .add("retry","3")
                    .go(callable)
                }
            }
            FluProgressButton{
                id:btn_upload
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Upload File"
                onClicked: {
                    file_dialog.open()
                }
            }
            FluProgressButton{
                id:btn_download
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Download File"
                onClicked: {
                    folder_dialog.showDialog(function(path){
                        FluNetwork.get("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
                        .toDownload(path)
                        .go(callable_download_file)
                    })
                }
            }
            FluProgressButton{
                id:btn_download_breakpoint
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Breakpoint Download File"
                onClicked: {
                    folder_dialog.showDialog(function(path){
                        FluNetwork.get("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
                        .toDownload(path,true)
                        .go(callable_breakpoint_download_file)
                    })
                }
            }
        }
    }

    FluNetworkCallable{
        id:callable_upload_file
        onStart: {
            btn_upload.disabled = true
        }
        onFinish: {
            btn_upload.disabled = false
        }
        onError:
            (status,errorString,result)=>{
                btn_upload.progress = 0
                text_info.text = result
                console.debug(result)
            }
        onSuccess:
            (result)=>{
                text_info.text = result
            }
        onUploadProgress:
            (sent,total)=>{
                btn_upload.progress = sent/total
            }
    }

    FluNetworkCallable{
        id:callable_download_file
        onStart: {
            btn_download.progress = 0
            btn_download.disabled = true
        }
        onFinish: {
            btn_download.disabled = false
        }
        onError:
            (status,errorString,result)=>{
                btn_download.progress = 0
                showError(errorString)
                console.debug(status+";"+errorString+";"+result)
            }
        onSuccess:
            (result)=>{
                showSuccess(result)
            }
        onDownloadProgress:
            (recv,total)=>{
                btn_download.progress = recv/total
            }
    }

    FluNetworkCallable{
        id:callable_breakpoint_download_file
        onStart: {
            btn_download_breakpoint.progress = 0
            btn_download_breakpoint.disabled = true
        }
        onFinish: {
            btn_download_breakpoint.disabled = false
        }
        onError:
            (status,errorString,result)=>{
                btn_download_breakpoint.progress = 0
                showError(errorString)
                console.debug(status+";"+errorString+";"+result)
            }
        onSuccess:
            (result)=>{
                showSuccess(result)
            }
        onDownloadProgress:
            (recv,total)=>{
                btn_download_breakpoint.progress = recv/total
            }
    }

    FileDialog {
        id: file_dialog
        onAccepted: {
            FluNetwork.postForm("https://httpbingo.org/post")
            .setRetry(0)//请求失败后不重复请求
            .add("accessToken","12345678")
            .addFile("file",FluTools.toLocalPath(file_dialog.selectedFile))
            .go(callable_upload_file)
        }
    }

    FileDialog {
        property var onSelectListener
        id: folder_dialog
        currentFile: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]+"/big_buck_bunny.mp4"
        fileMode: FileDialog.SaveFile
        onAccepted: {
            folder_dialog.onSelectListener(FluTools.toLocalPath(folder_dialog.currentFile))
        }
        function showDialog(listener){
            folder_dialog.onSelectListener = listener
            folder_dialog.open()
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
            boundsBehavior:Flickable.StopAtBounds
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
}
