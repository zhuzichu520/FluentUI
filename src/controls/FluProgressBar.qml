import QtQuick
import QtQuick.Controls

FluRectangle {
    id: control

    width: 150
    height: 5
    radius: [2.5,2.5,2.5,2.5]
    clip: true
    color:  FluTheme.isDark ? Qt.rgba(41/255,41/255,41/255,1) : Qt.rgba(214/255,214/255,214/255,1)
    property real progress: 0.5
    property bool indeterminate: true

    Component.onCompleted: {
        if(indeterminate){
            bar.x = -control.width*0.5
            behavior.enabled = true
            bar.x = control.width
        }else{
            bar.x = 0
        }
    }

    Rectangle{
        id:bar
        radius: 2.5
        width: control.width*progress
        height:  control.height
        color:FluTheme.isDark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark

        Behavior on x{
            id:behavior
            enabled: false
            NumberAnimation{
                duration: 1000
                onRunningChanged: {
                    if(!running){
                        behavior.enabled = false
                        bar.x = -control.width*0.5
                        behavior.enabled = true
                        bar.x = control.width
                    }
                }
            }
        }
    }
}
