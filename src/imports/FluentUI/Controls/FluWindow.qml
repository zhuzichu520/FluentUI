import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import org.wangwenx190.FramelessHelper

Window {
    enum LaunchMode {
        Standard,
        SingleTask,
        SingleInstance
    }
    default property alias content: container.data
    property bool fixSize
    property alias titleVisible: title_bar.titleVisible
    property bool appBarVisible: true
    property bool closeDestory: true
    property int launchMode: FluWindow.Standard
    property string route
    property var argument:({})
    property var pageRegister
    property var closeFunc: function(event){
        if(closeDestory){
            deleteWindow()
        }else{
            visible = false
            event.accepted = false
        }
    }
    property color backgroundColor: {
        if(active){
            return FluTheme.dark ? Qt.rgba(26/255,34/255,40/255,1) : Qt.rgba(238/255,244/255,249/255,1)
        }
        return FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
    }
    signal initArgument(var argument)
    id:window
    color:"transparent"
    onClosing:(event)=>closeFunc(event)
    Component.onCompleted: {
        helper.initWindow(window)
        initArgument(argument)
    }
    Rectangle{
        anchors.fill: parent
        color: backgroundColor
        Behavior on color{
            ColorAnimation {
                duration: 300
            }
        }
    }
    FluAppBar {
        id: title_bar
        title: window.title
        visible: window.appBarVisible
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }
    Item{
        id:container
        anchors{
            top: title_bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
    }
    FluInfoBar{
        id:infoBar
        root: window
    }
    FramelessHelper{
        id:framless_helper
        onReady: {
            setTitleBarItem(title_bar)
            framless_helper.moveWindowToDesktopCenter()
            setHitTestVisible(title_bar.minimizeButton())
            setHitTestVisible(title_bar.maximizeButton())
            setHitTestVisible(title_bar.closeButton())
            framless_helper.setWindowFixedSize(fixSize)
            title_bar.maximizeButton.visible = !fixSize
            window.visible = true
        }
    }
    WindowHelper{
        id:helper
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
        return helper.createRegister(window,path)
    }
    function deleteWindow(){
        helper.deleteWindow()
    }
    function setHitTestVisible(com){
        framless_helper.setHitTestVisible(com)
    }
    function setTitleBarItem(com){
        framless_helper.setTitleBarItem(com)
    }
    function onResult(data){
        if(pageRegister){
            pageRegister.onResult(data)
        }
    }
}
