import QtQuick 2.12
import QtQuick.Controls 2.12

FluRectangle {
    id: control

    width: 180
    height: 6
    radius: [3,3,3,3]
    clip: true
    color:  FluApp.isDark ? Qt.rgba(41/255,41/255,41/255,1) : Qt.rgba(214/255,214/255,214/255,1)
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
        radius: 3
        width: control.width*progress
        height:  control.height
        color:FluApp.isDark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark

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
