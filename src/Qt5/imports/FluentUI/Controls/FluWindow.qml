import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import org.wangwenx190.FramelessHelper 1.0

Window {
    default property alias content: container.data
    property bool closeDestory: true
    property int launchMode: FluWindowType.Standard
    property var argument:({})
    property var background : com_background
    property bool fixSize: false
    property Component loadingItem: com_loading
    property bool fitsAppBarWindows: false
    property Item appBar: FluAppBar {
        title: window.title
        width: window.width
        height: 30
        showDark: window.showDark
        showClose: window.showClose
        showMinimize: window.showMinimize
        showMaximize: window.showMaximize
        showStayTop: window.showStayTop
    }
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
    property bool useSystemAppBar: false
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
    maximumWidth: useSystemAppBar&&fixSize ? width : 16777215
    maximumHeight: useSystemAppBar&&fixSize ? height : 16777215
    minimumWidth: useSystemAppBar&&fixSize ? width : 0
    minimumHeight: useSystemAppBar&&fixSize ? height : 0
    color:"transparent"
    onStayTopChanged: {
        d.changedStayTop()
    }
    Component.onCompleted: {
        lifecycle.onCompleted(window)
        initArgument(argument)
        d.changedStayTop()
        if(useSystemAppBar){
            window.moveWindowToDesktopCenter()
            window.visible = true
        }
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
    FluLoader{
        anchors.fill: parent
        sourceComponent: background
    }
    FluLoader{
        id:loader_app_bar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        sourceComponent: window.useSystemAppBar ? undefined : com_app_bar
    }
    Component{
        id:com_app_bar
        Item{
            data: window.appBar
            height: window.fitsAppBarWindows ? 0 : childrenRect.height
        }
    }
    Item{
        id:container
        anchors{
            top: loader_app_bar.bottom
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
            flags = flags | Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint
            if(appBar){
                var appbar = window.appBar
                window.moveWindowToDesktopCenter()
                setWindowFixedSize(fixSize)
                if (blurBehindWindowEnabled)
                    window.background = undefined
            }
            window.show()
        }
    }
    WindowLifecycle{
        id:lifecycle
    }
    FluLoader{
        id:loader_window_border
        anchors.fill: parent
        z:999
        sourceComponent: window.useSystemAppBar ? undefined : com_window_border
    }
    Component{
        id:com_window_border
        Item{
            WindowBorder{
                anchors.fill: parent
                visible: !FluTools.isLinux()
            }
            Rectangle{
                anchors.fill: parent
                color: Qt.rgba(0,0,0,0)
                border.width: 1
                visible: FluTools.isLinux()
                border.color: {
                    if(window.active){
                        return Qt.rgba(51/255,51/255,51/255,1)
                    }
                    return Qt.rgba(153/255,153/255,153/255,1)
                }
            }
        }
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
    function moveWindowToDesktopCenter(){
        window.x = (Screen.desktopAvailableWidth - window.width)/2
        window.y = (Screen.desktopAvailableHeight - window.height)/2
    }
    function onResult(data){
        if(_pageRegister){
            _pageRegister.onResult(data)
        }
    }
}
