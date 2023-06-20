import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import "qrc:///example/qml/component"
import "qrc:///example/qml/global"

CustomWindow {

    id:window
    title: "FluentUI"
    width: 1000
    height: 640
    closeDestory:false
    minimumWidth: 520
    minimumHeight: 460
    appBarVisible: false
    launchMode: FluWindow.SingleTask

    closeFunc:function(event){
        close_app.open()
        event.accepted = false
    }

    Connections{
        target: appInfo
        function onActiveWindow(){
            window.show()
            window.raise()
            window.requestActivate()
        }
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
                    window.deleteWindow()
                    FluApp.closeApp()
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
        id:close_app
        title:"退出"
        message:"确定要退出程序吗？"
        negativeText:"最小化"
        buttonFlags: FluContentDialog.NeutralButton | FluContentDialog.NegativeButton | FluContentDialog.PositiveButton
        onNegativeClicked:{
            window.hide()
            system_tray.showMessage("友情提示","FluentUI已隐藏至托盘,点击托盘可再次激活窗口");
        }
        positiveText:"退出"
        neutralText:"取消"
        blurSource: nav_view
        onPositiveClicked:{
            window.deleteWindow()
            FluApp.closeApp()
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
            NumberAnimation { target: flipable; property: "flipAngle"; duration: 1000 ; easing.type: Easing.OutQuad}
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
                darkText: lang.dark_mode
                showDark: true
                z:7
                darkClickListener:(button)=>handleDarkChanged(button)
            }
            Row{
                z:8
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
                anchors.fill: parent
                //                source: "http://localhost:9000/RemoteComponent.qml"
                source: "https://zhu-zichu.gitee.io/RemoteComponent.qml"
            }
        }
        front: Item{
            id:page_front
            visible: flipable.flipAngle !== 180
            anchors.fill: flipable
            FluAppBar {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                darkText: lang.dark_mode
                showDark: true
                darkClickListener:(button)=>handleDarkChanged(button)
                z:7
            }
            FluNavigationView{
                property int clickCount: 0
                id:nav_view
                width: parent.width
                height: parent.height
                z:999
                items: ItemsOriginal
                footerItems:ItemsFooter
                topPadding:FluTools.isMacos() ? 20 : 5
                displayMode:MainEvent.displayMode
                logo: "qrc:/example/res/image/favicon.ico"
                title:"FluentUI"
                Behavior on rotation {
                    NumberAnimation{
                        duration: 167
                    }
                }
                transformOrigin: Item.Center
                onLoginClicked:{
                    clickCount += 1
                    if(clickCount === 1){
                        loader.reload()
                        flipable.flipped = true
                        clickCount = 0
                    }
                }
                autoSuggestBox:FluAutoSuggestBox{
                    width: 280
                    anchors.centerIn: parent
                    iconSource: FluentIcons.Search
                    items: ItemsOriginal.getSearchData()
                    placeholderText: lang.search
                    onItemClicked:
                        (data)=>{
                            ItemsOriginal.startPageByItem(data)
                        }
                }
                Component.onCompleted: {
                    ItemsOriginal.navigationView = nav_view
                    ItemsFooter.navigationView = nav_view
                    setCurrentIndex(0)
                }
            }
        }
    }

    Image{
        id:img_cache
        visible: false
        anchors.fill: parent
    }

    Canvas{
        id:canvas
        anchors.fill: parent
        property int centerX: canvas.width / 2
        property int centerY: canvas.height / 2
        property real radius: 0
        property int maxRadius: 0
        property url imageUrl
        Behavior on radius{
            id:anim_radius
            NumberAnimation {
                target: canvas
                property: "radius"
                duration: 333
                easing.type: Easing.OutCubic
            }
        }
        onRadiusChanged: {
            canvas.requestPaint()
        }
        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            ctx.clearRect(0, 0, canvasSize.width, canvasSize.height);
            ctx.save()
            if(img_cache.source.toString().length!==0){
                try{
                    ctx.drawImage(img_cache, 0, 0,  canvasSize.width, canvasSize.height, 0, 0,  canvasSize.width, canvasSize.height)
                }catch(e){
                    img_cache.source = ""
                }
            }
            clearArc(ctx, centerX, centerY, radius)
            ctx.restore()
        }
        function clearArc(ctx,x, y, radius, startAngle, endAngle) {
            ctx.beginPath()
            ctx.globalCompositeOperation = 'destination-out'
            ctx.fillStyle = 'black'
            ctx.arc(x, y, radius, 0, 2*Math.PI);
            ctx.fill();
            ctx.closePath();
        }
    }

    function distance(x1,y1,x2,y2){
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function handleDarkChanged(button){
        var changeDark = function(){
            if(FluTheme.dark){
                FluTheme.darkMode = FluDarkMode.Light
            }else{
                FluTheme.darkMode = FluDarkMode.Dark
            }
        }
        if(FluTools.isWin()){
            var target = window.contentItem
            var pos = button.mapToItem(target,0,0)
            var mouseX = pos.x
            var mouseY = pos.y
            canvas.maxRadius = Math.max(distance(mouseX,mouseY,0,0),distance(mouseX,mouseY,target.width,0),distance(mouseX,mouseY,0,target.height),distance(mouseX,mouseY,target.width,target.height))
            target.grabToImage(function(result) {
                img_cache.source = result.url
                canvas.requestPaint()
                changeDark()
                canvas.centerX = mouseX
                canvas.centerY = mouseY
                anim_radius.enabled = false
                canvas.radius = 0
                anim_radius.enabled = true
                canvas.radius = canvas.maxRadius
            },canvas.canvasSize)
        }else{
            changeDark()
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


}
