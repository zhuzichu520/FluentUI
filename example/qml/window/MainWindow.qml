import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import "../component"
import "qrc:///example/qml/global/"

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
        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis { x: 0; y: 1; z: 0 }
            angle: 0

        }
        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }
            when: flipable.flipped
        }
        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 1000 ; easing.type: Easing.OutQuad}
        }
        back: Item{
            anchors.fill: flipable
            visible: rotation.angle !== 0
            FluAppBar {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                darkText: lang.dark_mode
                showDark: true
                z:7
            }
            FluIconButton{
                iconSource: FluentIcons.ChromeBack
                width: 30
                height: 30
                iconSize: 13
                z:8
                onClicked: {
                    flipable.flipped = false
                }
            }
            FluText{
                font: FluTextStyle.Title
                text:"建设中..."
                anchors.centerIn: parent
            }
        }
        front: Item{
            visible: rotation.angle !== 180
            anchors.fill: flipable
            FluAppBar {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                darkText: lang.dark_mode
                showDark: true
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
                    if(clickCount === 5){
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
}
