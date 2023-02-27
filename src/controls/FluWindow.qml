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

    onIsMaxChanged: {
        if(isMax){
            root.anchors.margins = 4
            root.anchors.fill = parent
        }else{
            root.anchors.margins = 0
            root.anchors.fill = null
        }
    }

    color : FluApp.isDark ? "#202020" : "#F3F3F3"

    Component.onCompleted: {

    }

    WindowHelper{
        id:helper
    }

}
