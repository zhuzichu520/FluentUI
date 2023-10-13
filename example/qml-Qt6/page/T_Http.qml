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
    property string cacheDirPath: StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation) + "/cache/http"
    property bool isDownCompleted: false

    FluHttp{
        id:http
        cacheDir:cacheDirPath
    }

    FluHttp{
        id:http_breakpoint_download
        cacheDir:cacheDirPath
        breakPointDownload: true
    }

    FluHttp{
        id:http_cache_ifnonecacherequest
        cacheMode:FluHttpType.IfNoneCacheRequest
        cacheDir:cacheDirPath
    }

    FluHttp{
        id:http_cache_requestfailedreadcache
        cacheMode:FluHttpType.RequestFailedReadCache
        cacheDir:cacheDirPath
    }

    FluHttp{
        id:http_cache_firstcachethenrequest
        cacheMode:FluHttpType.FirstCacheThenRequest
        cacheDir:cacheDirPath
    }

    HttpCallable{
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
        onSuccess:
            (result)=>{
                text_info.text = result
            }
        onCache:
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
                    var request = http.newRequest("https://httpbingo.org/get")
                    http.get(request,callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post表单请求"
                onClicked: {
                    var request = http.newRequest("https://httpbingo.org/post")
                    var params = {}
                    params.custname = "朱子楚"
                    params.custtel = "1234567890"
                    params.custemail = "zhuzichu520@gmail.com"
                    request.params = params
                    var headers = {}
                    headers.test = "123456789456465321354"
                    request.headers = headers
                    http.post(request,callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post Json请求"
                onClicked: {
                    var request = http.newRequest("https://httpbingo.org/post")
                    var params = {}
                    params.custname = "朱子楚"
                    params.custtel = "1234567890"
                    params.custemail = "zhuzichu520@gmail.com"
                    request.params = params
                    http.postJson(request,callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post String请求"
                onClicked: {
                    var request = http.newRequest("https://httpbingo.org/post")
                    request.params = "我命由我不由天"
                    http.postString(request,callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Delete请求"
                onClicked: {
                    var request = http.newRequest("https://httpbingo.org/delete")
                    http.deleteResource(request,callable)
                }
            }
            FluProgressButton{
                id:btn_download
                implicitWidth: parent.width
                implicitHeight: 36
                text: "下载文件"
                onClicked: {
                    folder_dialog.open()
                }
            }
            FluProgressButton{
                property bool downloading: false
                id:btn_breakpoint_download
                implicitWidth: parent.width
                implicitHeight: 36
                text: {
                    if(downloading){
                        return "暂停下载"
                    }
                    if(progress === 0){
                        return "断点下载文件"
                    }else if(progress === 1){
                        return "打开文件"
                    }else{
                        return "继续下载"
                    }
                }
                HttpRequest{
                    id:request_breakpoint_download
                    url: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
                    downloadSavePath: FluTools.getApplicationDirPath()+ "/download/big_buck_bunny.mp4"
                }
                HttpCallable{
                    id:callable_breakpoint_download
                    onStart: {
                        btn_breakpoint_download.downloading = true
                    }
                    onFinish: {
                        btn_breakpoint_download.downloading = false
                    }
                    onError:
                        (status,errorString,result)=>{
                            console.debug(status+";"+errorString+";"+result)
                        }
                    onSuccess:
                        (result)=>{
                            if(!isDownCompleted){
                                tour.open()
                                isDownCompleted = true
                            }
                            showSuccess(result)
                        }
                    onDownloadProgress:
                        (recv,total)=>{
                            btn_breakpoint_download.progress = recv/total
                        }
                }
                Component.onCompleted: {
                    progress = http_breakpoint_download.getBreakPointProgress(request_breakpoint_download)
                }
                onClicked: {
                    if(downloading){
                        http_breakpoint_download.cancel()
                        return
                    }
                    if(progress === 1){
                        FluTools.showFileInFolder(request_breakpoint_download.downloadSavePath)
                    }else{
                        http_breakpoint_download.download(request_breakpoint_download,callable_breakpoint_download)
                    }
                }
                FluMenu{
                    id:menu_breakpoint_download
                    width: 120
                    FluMenuItem{
                        text: "删除文件"
                        onClicked: {
                            if(FluTools.removeFile(request_breakpoint_download.downloadSavePath)){
                                btn_breakpoint_download.progress = 0
                            }
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        if(btn_breakpoint_download.progress === 1){
                            menu_breakpoint_download.popup()
                        }
                    }
                }
            }
            FluProgressButton{
                id:btn_upload
                implicitWidth: parent.width
                implicitHeight: 36
                text: "文件上传"
                onClicked: {
                    file_dialog.open()
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "FirstCacheThenRequest缓存"
                onClicked: {
                    var request = http.newRequest("https://httpbingo.org/post")
                    request.params = {cacheMode:"FirstCacheThenRequest"}
                    http_cache_firstcachethenrequest.post(request,callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "RequestFailedReadCache缓存"
                onClicked: {
                    var request = http.newRequest("https://httpbingo.org/post")
                    request.params = {cacheMode:"RequestFailedReadCache"}
                    http_cache_requestfailedreadcache.post(request,callable)
                }
            }

            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "IfNoneCacheRequest缓存"
                onClicked: {
                    var request = http.newRequest("https://httpbingo.org/post")
                    request.params = {cacheMode:"IfNoneCacheRequest"}
                    http_cache_ifnonecacherequest.post(request,callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "打开缓存路径"
                onClicked: {
                    Qt.openUrlExternally(cacheDirPath)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "删除缓存"
                onClicked: {
                    console.debug(FluTools.removeDir(cacheDirPath))
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "清空右边数据"
                onClicked: {
                    text_info.text = ""
                }
            }
        }
    }

    FluTour{
        id:tour
        steps:[
            {title:"友情提示",description: "下载已完成，左击这里可以打开文件所在路径，右击可以弹出菜单删除文件！",target:()=>btn_breakpoint_download}
        ]
    }

    HttpCallable{
        id:callable_upload
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
    FileDialog {
        id: file_dialog
        onAccepted: {
            var request = http.newRequest("https://httpbingo.org/post")
            var params = {}
            for(var i=0;i<selectedFiles.length;i++){
                var fileUrl = selectedFiles[i]
                var fileName = FluTools.getFileNameByUrl(fileUrl)
                var filePath = FluTools.toLocalPath(fileUrl)
                params[fileName] = filePath
            }
            request.params = params
            http.upload(request,callable_upload)
        }
    }

    HttpCallable{
        id:callable_download
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
    FolderDialog {
        id: folder_dialog
        currentFolder: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
        onAccepted: {
            var request = http.newRequest("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
            request.downloadSavePath = FluTools.toLocalPath(currentFolder)+ "/big_buck_bunny.mp4"
            http.download(request,callable_download)
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
