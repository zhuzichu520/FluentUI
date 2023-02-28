import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle {

    id:root
    property bool isMax: {
        if(Window.window == null)
            return false
        return Window.Maximized === Window.window.visibility
    }
    property string title: "FluentUI"

    Behavior on opacity{
        NumberAnimation{
            duration: 100
        }
    }

    property var window : {
        if(Window.window == null)
            return null
        return Window.window
    }

    onIsMaxChanged: {
        if(isMax){
            root.anchors.margins = 8*(1/Screen.devicePixelRatio)
            root.anchors.fill = parent
        }else{
            root.anchors.margins = 0
            root.anchors.fill = null
        }
    }

    color : FluApp.isDark ? "#202020" : "#F3F3F3"

    Component.onCompleted: {
        console.debug("onCompleted")
    }

    Connections{
        target: FluApp
        function onWindowReady(view){
            if(FluApp.equalsWindow(view,window)){
                helper.initWindow(view);
                helper.setTitle(title);
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



}
