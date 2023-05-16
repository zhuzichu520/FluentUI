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
    property alias windowIcon: titleBar.windowIcon
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
    visible: false
    objectName: title
    onClosing:(event)=>closeFunc(event)
    Component.onCompleted: {
        helper.initWindow(window)
        initArgument(argument)
    }
    color: {
        if (FramelessHelper.blurBehindWindowEnabled) {
            return "transparent";
        }
        return backgroundColor;
    }
    Behavior on color{
        ColorAnimation {
            duration: 300
        }
    }
    StandardTitleBar {
        id: titleBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        windowIconVisible: windowIcon!==null
        RowLayout{
            spacing: 10
            Item {
                width: 10
            }
            FluIconButton{
                iconSize: 10
                iconSource: FluentIcons.ChromeClose
                onClicked: window.close()
            }
            FluIconButton{
                iconSize: 10
                iconSource: FluentIcons.ChromeMinimize
                onClicked: window.visibility = Window.Minimized
            }
            FluIconButton{
                iconSize: 10
                iconSource: FluentIcons.ChromeMaximize
                onClicked:
                {
                    if (window.visibility === Window.Maximized)
                        window.visibility = Window.Windowed
                    else
                        window.visibility = Window.Maximized
                }
            }
        }
    }
    Item{
        id:container
        anchors{
            top: titleBar.bottom
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
    WindowHelper{
        id:helper
    }
    FramelessHelper.onReady: {
        FramelessHelper.titleBarItem = titleBar;
        FramelessHelper.moveWindowToDesktopCenter();
        window.visible = true;
    }

    function showSuccess(text,duration,moremsg){
        infoBar.showSuccess(text,duration,moremsg);
    }
    function showInfo(text,duration,moremsg){
        infoBar.showInfo(text,duration,moremsg);
    }
    function showWarning(text,duration,moremsg){
        infoBar.showWarning(text,duration,moremsg);
    }
    function showError(text,duration,moremsg){
        infoBar.showError(text,duration,moremsg);
    }
    function registerForWindowResult(path){
        return helper.createRegister(window,path)
    }
    function deleteWindow(){
        helper.deleteWindow()
    }
    function onResult(data){
        if(pageRegister){
            pageRegister.onResult(data)
        }
    }

}
