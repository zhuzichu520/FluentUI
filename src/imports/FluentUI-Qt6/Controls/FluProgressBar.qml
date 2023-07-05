import QtQuick
import QtQuick.Controls
import FluentUI

Item{

    property real progress: 0.5
    property bool indeterminate: true
    property bool progressVisible: false
    id: control
    width: 150
    height: 5

    FluRectangle {
        shadow: false
        radius: [3,3,3,3]
        anchors.fill: parent
        color:  FluTheme.dark ? Qt.rgba(99/255,99/255,99/255,1) : Qt.rgba(214/255,214/255,214/255,1)
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
            color:FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
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

    FluText{
        text:(control.progress * 100).toFixed(0) + "%"
        font.pixelSize: 10
        visible: {
            if(control.indeterminate){
                return false
            }
            return control.progressVisible
        }
        anchors{
            left: parent.left
            leftMargin: control.width+5
            verticalCenter: parent.verticalCenter
        }
    }
}

