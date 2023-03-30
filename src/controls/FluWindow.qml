import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import FluentUI

Item {

    property string title: "FluentUI"
    property int minimumWidth
    property int maximumWidth
    property int minimumHeight
    property int maximumHeight
    property int modality:0
    signal initArgument(var argument)
    property var pageRegister
    default property alias content: container.data
    property var window : {
        if(Window.window == null)
            return null
        return Window.window
    }

    property color color: {
        if(window && window.active){
            return FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(238/255,244/255,249/255,1)
        }
        return FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
    }

    id:root

    Behavior on opacity{
        NumberAnimation{
            duration: 100
        }
    }

    Rectangle{
        id:container
        color:root.color
        anchors.fill: parent
        anchors.margins: (window && (window.visibility === Window.Maximized) && FluTheme.frameless) ? 8/Screen.devicePixelRatio : 0
        clip: true
        Behavior on color{
            ColorAnimation {
                duration: 300
            }
        }
    }

    Rectangle{
        border.width: 1
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0,)
        border.color:FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,230/255,234/255,1)
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

    function registerForPageResult(path){
        return helper.createRegister(path)
    }

    function onResult(data){
        if(pageRegister){
            pageRegister.onResult(data)
        }
    }

}
