import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import FluentUI

Item {

    id:root

    property var window : {
        if(Window.window == null)
            return null
        return Window.window
    }

    property color color: {
        if(window && window.active){
            return FluTheme.isDark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(238/255,244/255,249/255,1)
        }
        return FluTheme.isDark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
    }

    property string title: "FluentUI"
    property int minimumWidth
    property int maximumWidth
    property int minimumHeight
    property int maximumHeight
    property int modality:0

    signal initArgument(var argument)

    property var pageRegister

    property int borderless:{
        if(!FluTheme.isFrameless){
            return 0
        }
        return (window && (window.visibility === Window.Maximized)) ? 0 : 4
    }

    default property alias content: container.data

    FluWindowResize{
        border:borderless
    }

    Behavior on opacity{
        NumberAnimation{
            duration: 100
        }
    }

    Rectangle{
        property color borerlessColor : FluTheme.isDark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
        color:  (window && window.active) ? borerlessColor : Qt.lighter(borerlessColor,1.1)
        border.width: 1
        anchors.fill: parent
        radius: 4
        border.color:FluTheme.isDark ? Qt.darker(FluTheme.primaryColor.lighter,1.3) : Qt.lighter(FluTheme.primaryColor.dark,1.2)
    }

    Rectangle{
        id:container
        color:root.color
        anchors.fill: parent
        anchors.margins: borderless
        clip: true
        Behavior on color{
            ColorAnimation {
                duration: 300
            }
        }
    }

    Component.onCompleted: {
        updateWindowSize()
    }

    Connections{
        target: FluTheme
        function onIsFramelessChanged(){
            updateWindowSize()
        }
    }

    function updateWindowSize(){
        if(FluTheme.isFrameless){
            height = height + 34
        }else{
            height = height - 34
        }
    }

    Connections{
        target: FluApp
        function onWindowReady(view){
            if(FluApp.equalsWindow(view,window)){
                helper.initWindow(view)
                initArgument(helper.getArgument())
                pageRegister = helper.getPageRegister()
                helper.setTitle(title)
                if(minimumWidth){
                    helper.setMinimumWidth(minimumWidth)
                }
                if(maximumWidth){
                    helper.setMaximumWidth(maximumWidth)
                }
                if(minimumHeight){
                    helper.setMinimumHeight(minimumHeight)
                }
                if(maximumHeight){
                    helper.setMaximumHeight(maximumHeight)
                }
                helper.setModality(root.modality);
                helper.updateWindow()
            }
        }
    }

    WindowHelper{
        id:helper
    }

    FluInfoBar{
        id:infoBar
        root: root
    }

    function showSuccess(text,duration=1000,moremsg){
        infoBar.showSuccess(text,duration,moremsg);
    }

    function showInfo(text,duration=1000,moremsg){
        infoBar.showInfo(text,duration,moremsg);
    }

    function showWarning(text,duration=1000,moremsg){
        infoBar.showWarning(text,duration,moremsg);
    }

    function showError(text,duration=1000,moremsg){
        infoBar.showError(text,duration,moremsg);
    }

    function close(){
        window.close()
    }

    function registerForPageResult(path){
        return helper.createRegister(path)
    }

    function onResult(data){
        if(pageRegister){
            pageRegister.onResult(data)
        }
    }

}
