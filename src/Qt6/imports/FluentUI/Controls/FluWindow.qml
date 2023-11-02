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
            return FluTheme.windowActiveBackgroundColor
        }
        return FluTheme.windowBackgroundColor
    }
    property bool stayTop: false
    property var _pageRegister
    property string _route
    property bool showDark: false
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showStayTop: true
    property var closeListener: function(event){
        if(closeDestory){
            destoryOnClose()
        }else{
            visible = false
            event.accepted = false
        }
    }
    signal initArgument(var argument)
    id:window
    flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint
    color:"transparent"
    onStayTopChanged: {
        d.changedStayTop()
    }
    Component.onCompleted: {
        lifecycle.onCompleted(window)
        initArgument(argument)
        d.changedStayTop()
    }
    Component.onDestruction: {
        lifecycle.onDestruction()
    }
    onVisibleChanged: {
        lifecycle.onVisible(visible)
    }
    QtObject{
        id:d
        function changedStayTop(){
            function toggleStayTop(){
                if(window.stayTop){
                    window.flags = window.flags | Qt.WindowStaysOnTopHint
                }else{
                    window.flags = window.flags &~ Qt.WindowStaysOnTopHint
                }
            }
            if(window.visibility === Window.Maximized){
                window.visibility = Window.Windowed
                toggleStayTop()
                window.visibility = Window.Maximized
            }else{
                toggleStayTop()
            }
        }
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
            showDark: window.showDark
            showClose: window.showClose
            showMinimize: window.showMinimize
            showMaximize: window.showMaximize
            showStayTop: window.showStayTop
        }
    }
    FluLoader{
        anchors.fill: parent
        sourceComponent: background
    }
    FluLoader{
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
    FluLoader{
        property string loadingText: "加载中..."
        property bool cancel: false
        id:loader_loading
        anchors.fill: container
    }
    Component{
        id:com_loading
        Popup{
            id:popup_loading
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
            if(appBar){
                var title_bar = loader_title_bar.item
                setTitleBarItem(title_bar)
                moveWindowToDesktopCenter()
                setHitTestVisible(title_bar.minimizeButton())
                setHitTestVisible(title_bar.maximizeButton())
                setHitTestVisible(title_bar.closeButton())
                setHitTestVisible(title_bar.stayTopButton())
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
    WindowBorder{
        z:999
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
