import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1
import FluentUI 1.0
import example 1.0
import "qrc:///example/qml/component"
import "qrc:///example/qml/global"
import "qrc:///example/qml/viewmodel"
import "../component"
import "../viewmodel"
import "../global"

FluWindow {

    id:window
    title: "FluentUI"
    width: 1000
    height: 640
    minimumWidth: 520
    minimumHeight: 200
    launchMode: FluWindowType.SingleTask
    appBar: undefined

    SettingsViewModel{
        id:viewmodel_settings
    }

    FluEvent{
        id:event_checkupdate
        name: "checkUpdate"
        onTriggered: {
            checkUpdate(false)
        }
    }

    Component.onCompleted: {
        tour.open()
        checkUpdate(true)
        FluEventBus.registerEvent(event_checkupdate)
    }

    Component.onDestruction: {
        FluEventBus.unRegisterEvent(event_checkupdate)
    }

    SystemTrayIcon {
        id:system_tray
        visible: true
        icon.source: "qrc:/example/res/image/favicon.ico"
        tooltip: "FluentUI"
        menu: Menu {
            MenuItem {
                text: "退出"
                onTriggered: {
                    FluApp.exit()
                }
            }
        }
        onActivated:
            (reason)=>{
                if(reason === SystemTrayIcon.Trigger){
                    window.show()
                    window.raise()
                    window.requestActivate()
                }
            }
    }

    FluContentDialog{
        id:dialog_close
        title:"退出"
        message:"确定要退出程序吗？"
        negativeText:"最小化"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.NeutralButton | FluContentDialogType.PositiveButton
        onNegativeClicked:{
            window.hide()
            system_tray.showMessage("友情提示","FluentUI已隐藏至托盘,点击托盘可再次激活窗口");
        }
        positiveText:"退出"
        neutralText:"取消"
        onPositiveClicked:{
            FluApp.exit(0)
        }
    }

    Component{
        id:nav_item_right_menu
        FluMenu{
            id:menu
            width: 130
            FluMenuItem{
                text: "在独立窗口打开"
                visible: true
                onClicked: {
                    FluApp.navigate("/pageWindow",{title:modelData.title,url:modelData.url})
                }
            }
        }
    }

    Flipable{
        id:flipable
        anchors.fill: parent
        property bool flipped: false
        property real flipAngle: 0
        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis { x: 0; y: 1; z: 0 }
            angle: flipable.flipAngle

        }
        states: State {
            PropertyChanges { target: flipable; flipAngle: 180 }
            when: flipable.flipped
        }
        transitions: Transition {
            NumberAnimation { target: flipable; property: "flipAngle"; duration: 1000 ; easing.type: Easing.OutCubic}
        }
        back: Item{
            anchors.fill: flipable
            visible: flipable.flipAngle !== 0
            FluAppBar {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                darkText: Lang.dark_mode
                showDark: true
                z:7
                darkClickListener:(button)=>handleDarkChanged(button)
                closeClickListener: ()=>{dialog_close.open()}
            }
            Row{
                z:8
                anchors{
                    top: parent.top
                    left: parent.left
                    topMargin: FluTools.isMacos() ? 20 : 5
                    leftMargin: 5
                }
                FluIconButton{
                    iconSource: FluentIcons.ChromeBack
                    width: 30
                    height: 30
                    iconSize: 13
                    onClicked: {
                        flipable.flipped = false
                    }
                }
                FluIconButton{
                    iconSource: FluentIcons.Sync
                    width: 30
                    height: 30
                    iconSize: 13
                    onClicked: {
                        loader.reload()
                    }
                }
            }
            FluRemoteLoader{
                id:loader
                lazy: true
                anchors.fill: parent
                source: "https://zhu-zichu.gitee.io/Qt5_156_LieflatPage.qml"
            }
        }
        front: Item{
            id:page_front
            visible: flipable.flipAngle !== 180
            anchors.fill: flipable
            FluAppBar {
                id:app_bar_front
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                darkText: Lang.dark_mode
                showDark: true
                darkClickListener:(button)=>handleDarkChanged(button)
                closeClickListener: ()=>{dialog_close.open()}
                z:7
            }
            FluNavigationView{
                property int clickCount: 0
                id:nav_view
                width: parent.width
                height: parent.height
                z:999
                //Stack模式，每次切换都会将页面压入栈中，随着栈的页面增多，消耗的内存也越多，内存消耗多就会卡顿，这时候就需要按返回将页面pop掉，释放内存。该模式可以配合FluPage中的launchMode属性，设置页面的启动模式
                //                pageMode: FluNavigationViewType.Stack
                //NoStack模式，每次切换都会销毁之前的页面然后创建一个新的页面，只需消耗少量内存，可以配合FluViewModel保存页面数据（推荐）
                pageMode: FluNavigationViewType.NoStack
                items: ItemsOriginal
                footerItems:ItemsFooter
                topPadding:FluTools.isMacos() ? 20 : 0
                displayMode:viewmodel_settings.displayMode
                logo: "qrc:/example/res/image/favicon.ico"
                title:"FluentUI"
                onLogoClicked:{
                    clickCount += 1
                    showSuccess("点击%1次".arg(clickCount))
                    if(clickCount === 5){
                        loader.reload()
                        flipable.flipped = true
                        clickCount = 0
                    }
                }
                autoSuggestBox:FluAutoSuggestBox{
                    iconSource: FluentIcons.Search
                    items: ItemsOriginal.getSearchData()
                    placeholderText: Lang.search
                    onItemClicked:
                        (data)=>{
                            ItemsOriginal.startPageByItem(data)
                        }
                }
                Component.onCompleted: {
                    ItemsOriginal.navigationView = nav_view
                    ItemsOriginal.paneItemMenu = nav_item_right_menu
                    ItemsFooter.navigationView = nav_view
                    ItemsFooter.paneItemMenu = nav_item_right_menu
                    setCurrentIndex(0)
                }
            }
        }
    }

    Component{
        id:com_reveal
        CircularReveal{
            id:reveal
            target:window.contentItem
            anchors.fill: parent
            onAnimationFinished:{
                //动画结束后释放资源
                loader_reveal.sourceComponent = undefined
            }
            onImageChanged: {
                changeDark()
            }
        }
    }

    FluLoader{
        id:loader_reveal
        anchors.fill: parent
    }

    function distance(x1,y1,x2,y2){
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function handleDarkChanged(button){
        if(!FluTheme.enableAnimation){
            changeDark()
        }else{
            loader_reveal.sourceComponent = com_reveal
            var target = window.contentItem
            var pos = button.mapToItem(target,0,0)
            var mouseX = pos.x
            var mouseY = pos.y
            var radius = Math.max(distance(mouseX,mouseY,0,0),distance(mouseX,mouseY,target.width,0),distance(mouseX,mouseY,0,target.height),distance(mouseX,mouseY,target.width,target.height))
            var reveal = loader_reveal.item
            reveal.start(reveal.width*Screen.devicePixelRatio,reveal.height*Screen.devicePixelRatio,Qt.point(mouseX,mouseY),radius)
        }
    }

    function changeDark(){
        if(FluTheme.dark){
            FluTheme.darkMode = FluThemeType.Light
        }else{
            FluTheme.darkMode = FluThemeType.Dark
        }
    }

    Shortcut {
        sequence: "F5"
        context: Qt.WindowShortcut
        onActivated: {
            if(flipable.flipped){
                loader.reload()
            }
        }
    }

    Shortcut {
        sequence: "F6"
        context: Qt.WindowShortcut
        onActivated: {
            tour.open()
        }
    }

    FluTour{
        id:tour
        steps:[
            {title:"夜间模式",description: "这里可以切换夜间模式.",target:()=>app_bar_front.darkButton()},
            {title:"隐藏彩蛋",description: "多点几下试试！！",target:()=>nav_view.logoButton()}
        ]
    }

    FluHttp{
        id:http
    }

    FpsItem{
        id:fps_item
    }

    FluText{
        text:"fps %1".arg(fps_item.fps)
        opacity: 0.3
        anchors{
            bottom: parent.bottom
            right: parent.right
            bottomMargin: 5
            rightMargin: 5
        }
    }

    FluContentDialog{
        property string newVerson
        property string body
        id:dialog_update
        title:"升级提示"
        message:"FluentUI目前最新版本 "+ newVerson +" -- 当前应用版本 "+AppInfo.version+" \n现在是否去下载新版本？\n\n更新内容：\n"+body
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: "取消"
        positiveText:"确定"
        onPositiveClicked:{
            Qt.openUrlExternally("https://github.com/zhuzichu520/FluentUI/releases/latest")
        }
    }

    HttpCallable{
        id:callable
        property bool silent: true
        onStart: {
            console.debug("satrt check update...")
        }
        onFinish: {
            console.debug("check update finish")
            FluEventBus.post("checkUpdateFinish");
        }
        onSuccess:
            (result)=>{
                var data = JSON.parse(result)
                console.debug("current version "+AppInfo.version)
                console.debug("new version "+data.tag_name)
                if(data.tag_name !== AppInfo.version){
                    dialog_update.newVerson =  data.tag_name
                    dialog_update.body = data.body
                    dialog_update.open()
                }else{
                    if(!silent){
                        showInfo("当前版本已经是最新版")
                    }
                }
            }
        onError:
            (status,errorString)=>{
                if(!silent){
                    showError("网络异常!")
                }
                console.debug(status+";"+errorString)
            }
    }

    function checkUpdate(silent){
        callable.silent = silent
        var request = http.newRequest("https://api.github.com/repos/zhuzichu520/FluentUI/releases/latest")
        http.get(request,callable);
    }

}
