import QtQuick 2.12
import QtQuick.Controls 2.12

//进度条4
FluRectangle {
    id: control

    width: 180
    height: 6
    radius: [3,3,3,3]
    clip: true
    color:Qt.rgba(214/255,214/255,214/255,1)
    property real progress: 0.25
    property bool indeterminate: true

    Component.onCompleted: {
        anim.enabled = false
        if(indeterminate){
            rect.x = -control.width*0.5
        }else{
            rect.x = 0
        }
        anim.enabled = true
    } 

    Rectangle{
        id:rect
        radius: 3
        width: control.width*progress
        height:  control.height
        color:Qt.rgba(0/255,102/255,180/255,1)

        Behavior on x{
            id:anim
            enabled: true
            NumberAnimation{
                duration: 800
                onRunningChanged: {
                    if(!running){
                        anim.enabled = false
                        rect.x = -control.width*0.5
                        anim.enabled = true
                        timer.start()
                    }
                }
            }
        }

        Timer{
            id:timer
            running: indeterminate
            interval: 800
            triggeredOnStart: true
            onTriggered: {
                rect.x = control.width
            }
        }
    }
}
