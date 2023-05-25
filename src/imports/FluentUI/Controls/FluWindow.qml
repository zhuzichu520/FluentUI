import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
ApplicationWindow {
    enum LaunchMode {
        Standard,
        SingleTask,
        SingleInstance
    }
    default property alias content: container.data
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
            return G.FluTheme.dark ? Qt.rgba(26/255,34/255,40/255,1) : Qt.rgba(238/255,244/255,249/255,1)
        }
        return G.FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
    }
    property alias backgroundOpacity: bg.opacity
    property alias backgroundVisible: bg.visible
    signal initArgument(var argument)
    id:window
    color:"transparent"
    onClosing:(event)=>closeFunc(event)
    Component.onCompleted: {
        helper.initWindow(window)
        initArgument(argument)
    }
    FontLoader{
        source: "../Font/Segoe_Fluent_Icons.ttf"
    }
    Rectangle{
        id: bg
        anchors.fill: parent
        color: backgroundColor
        Behavior on color{
            ColorAnimation {
                duration: 300
            }
        }
    }
    Item{
        id:container
        anchors.fill: parent
        clip: true
    }
    FluInfoBar{
        id:infoBar
        root: window
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
    function onResult(data){
        if(pageRegister){
            pageRegister.onResult(data)
        }
    }
}
