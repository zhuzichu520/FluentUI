import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15

Item{

    id:root

    property int lineWidth: 6
    property int dotSize: 30
    property int value: 50

    Component.onCompleted: {
        dot.x =value/100*control.width - dotSize/2
        root.value = Qt.binding(function(){
            return (dot.x+15)/control.width*100
        })
    }

    FluRectangle {

        id: control

        width: 300
        height: root.lineWidth
        radius: [3,3,3,3]
        clip: true
        anchors.verticalCenter: parent.verticalCenter
        color:FluApp.isDark ? Qt.rgba(162/255,162/255,162/255,1) : Qt.rgba(138/255,138/255,138/255,1)
        Rectangle{
            id:rect
            radius: 3
            width: control.width*(value/100)
            height:  control.height
            color:FluApp.isDark ? Qt.rgba(76/255,160/255,224/255,1) :Qt.rgba(0/255,102/255,180/255,1)
        }
    }

    Rectangle{
        id:dot
        width: dotSize
        height: dotSize
                FluShadow{
                radius: 15
                }
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        color:FluApp.isDark ? Qt.rgba(69/255,69/255,69/255,1) :Qt.rgba(1,1,1,1)
        Rectangle{
            width: dotSize/2
            height: dotSize/2
            radius: dotSize/4
            color:FluApp.isDark ? Qt.rgba(76/255,160/255,224/255,1) :Qt.rgba(0/255,102/255,180/255,1)
            anchors.centerIn: parent
            scale: control_mouse.containsMouse ? 1.2 : 1
            Behavior on scale {
                NumberAnimation{
                    duration: 150
                }
            }
        }
        MouseArea{
            id:control_mouse
            anchors.fill: parent
            hoverEnabled: true
            drag {
                target: dot
                axis: Drag.XAxis
                minimumX: -dotSize/2
                maximumX: control.width - dotSize/2
            }
            onPressed: {
                tool_tip.visible  =  true
            }

            onReleased: {
                tool_tip.visible  =  false
            }
        }

        FluTooltip{
            id:tool_tip
            text:String(root.value)
        }
    }

}

