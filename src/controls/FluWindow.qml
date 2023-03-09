import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import QtGraphicalEffects 1.15

Item {

    id:root

    property var window : {
        if(Window.window == null)
            return null
        return Window.window
    }

    property color color: FluTheme.isDark ? "#202020" : "#F3F3F3"
    property string title: "FluentUI"
    property int minimumWidth
    property int maximumWidth
    property int minimumHeight
    property int maximumHeight

    property int borderless:{
        if(!FluTheme.isFrameless){
            return 0
        }
        if(window === null)
            return 4
        if(Window.window.visibility === Window.Maximized){
            return 0
        }
        return 4
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
        color: {
            if(window === null)
                return borerlessColor
            return window.active ? borerlessColor : Qt.lighter(borerlessColor,1.1)
        }
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
    }

    Component.onCompleted: {

    }

    Connections{
        target: FluApp
        function onWindowReady(view){
            if(FluApp.equalsWindow(view,window)){
                helper.initWindow(view);
                helper.setTitle(title);
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
    function close(){
        window.close()
    }

}
