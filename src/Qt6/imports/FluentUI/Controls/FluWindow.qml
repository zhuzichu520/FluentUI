import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import org.wangwenx190.FramelessHelper

Window {
    default property alias content: container.data
    property bool closeDestory: true
    property int launchMode: FluWindowType.Standard
    property var argument:({})
    property var background : com_background
    property bool fixSize: false
    property Component loadingItem: com_loading
    property var appBar: com_app_bar
    property color backgroundColor: {
        if(active){
            return FluTheme.dark ? Qt.rgba(26/255,34/255,40/255,1) : Qt.rgba(243/255,243/255,243/255,1)
        }
        return FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(237/255,237/255,237/255,1)
    }
    property var _pageRegister
    property string _route
    property var closeListener: function(event){
        if(closeDestory){
            destoryOnClose()
        }else{
            visible = false
            event.accepted = false
        }
    }
    signal initArgument(var argument)
    property bool showSystemAppBar: true
    id:window
    color:"transparent"
    Component.onCompleted: {
        lifecycle.onCompleted(window)
        initArgument(argument)
    }
    Component.onDestruction: {
        lifecycle.onDestruction()
    }
    onVisibleChanged: {
        lifecycle.onVisible(visible)
    }
    Connections{
        target: window
        function onClosing(event){closeListener(event)}
    }
    Component{
        id:com_background
        Rectangle{
            color: window.backgroundColor
        }
    }
    Component{
        id:com_app_bar
        FluAppBar {
            title: window.title
        }
    }
    Loader{
        anchors.fill: parent
        sourceComponent: background
    }
    Loader{
        id: loader_title_bar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        sourceComponent: window.appBar
    }
    Item{
        id:container
        anchors{
            top: loader_title_bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
    }
    Loader{
        property string loadingText: "加载中..."
        property bool cancel: false
        id:loader_loading
        anchors.fill: container
    }
    Component{
        id:com_loading
        Popup{
            id:popup_loading
            modal:true
            focus: true
            width: window.width
            height: window.height
            anchors.centerIn: Overlay.overlay
            closePolicy: {
                if(cancel){
                    return Popup.CloseOnEscape | Popup.CloseOnPressOutside
                }
                return Popup.NoAutoClose
            }
            Overlay.modal: Item {}
            onVisibleChanged: {
                if(!visible){
                    loader_loading.sourceComponent = undefined
                }
            }
            padding: 0
            opacity: 0
            visible:true
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 88
                    }
                    NumberAnimation{
                        duration:  167
                    }
                }
            }
            Component.onCompleted: {
                opacity = 1
            }
            background: Rectangle{
                color:"#44000000"
            }
            contentItem: Item{
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (cancel){
                            popup_loading.visible = false
                        }
                    }
                }
                ColumnLayout{
                    spacing: 8
                    anchors.centerIn: parent
                    FluProgressRing{
                        Layout.alignment: Qt.AlignHCenter
                    }
                    FluText{
                        text:loadingText
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
    FluInfoBar{
        id:infoBar
        root: window
    }
    Connections{
        target: FluTheme
        function onDarkChanged(){
            if (FluTheme.dark)
                FramelessUtils.systemTheme = FramelessHelperConstants.Dark
            else
                FramelessUtils.systemTheme = FramelessHelperConstants.Light
        }
    }
    FramelessHelper{
        id:framless_helper
        onReady: {
            if(appBar && !showSystemAppBar){
                var title_bar = loader_title_bar.item
                setTitleBarItem(title_bar)
                moveWindowToDesktopCenter()
                setHitTestVisible(title_bar.minimizeButton())
                setHitTestVisible(title_bar.maximizeButton())
                setHitTestVisible(title_bar.closeButton())
                setWindowFixedSize(fixSize)
                title_bar.maximizeButton.visible = !fixSize
                if (blurBehindWindowEnabled)
                    window.background = undefined
            }
            window.show()
        }
    }
    WindowLifecycle{
        id:lifecycle
    }
    function destoryOnClose(){
        lifecycle.onDestoryOnClose()
    }
    function showLoading(text = "加载中...",cancel = true){
        loader_loading.loadingText = text
        loader_loading.cancel = cancel
        loader_loading.sourceComponent = com_loading
    }
    function hideLoading(){
        loader_loading.sourceComponent = undefined
    }
    function showSuccess(text,duration,moremsg){
        infoBar.showSuccess(text,duration,moremsg)
    }
    function showInfo(text,duration,moremsg){
        infoBar.showInfo(text,duration,moremsg)
    }
    function showWarning(text,duration,moremsg){
        infoBar.showWarning(text,duration,moremsg)
    }
    function showError(text,duration,moremsg){
        infoBar.showError(text,duration,moremsg)
    }
    function registerForWindowResult(path){
        return lifecycle.createRegister(window,path)
    }
    function onResult(data){
        if(_pageRegister){
            _pageRegister.onResult(data)
        }
    }
}
