import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15

Item{

    id:root

    property int lineSize: 5
    property int size: 180
    property int dotSize: 26

    property int value: 50

    enum Orientation  {
        Horizontal,
        Vertical
    }

    height: control.height
    width: control.width

    property int orientation: FluSlider.Horizontal

    property bool isHorizontal: orientation === FluSlider.Horizontal

    rotation: isHorizontal ? 0 : 180

    Component.onCompleted: {
        if(isHorizontal){
            dot.x =value/100*control.width - dotSize/2
            root.value = Qt.binding(function(){
                return (dot.x+dotSize/2)/control.width*100
            })
        }else{
            dot.y =value/100*control.height - dotSize/2
            root.value = Qt.binding(function(){
                return (dot.y+dotSize/2)/control.height*100
            })
        }
    }

    FluRectangle {
        id: control
        width: isHorizontal ? size : root.lineSize
        height:  isHorizontal ? root.lineSize : size
        radius: [3,3,3,3]
        clip: true
        anchors.verticalCenter: parent.verticalCenter
        color:FluTheme.isDark ? Qt.rgba(162/255,162/255,162/255,1) : Qt.rgba(138/255,138/255,138/255,1)
        Rectangle{
            id:rect
            radius: 3
            width: isHorizontal ? control.width*(value/100) : control.width
            height: isHorizontal ?  control.height  : control.height*(value/100)
            color:FluTheme.isDark ? FluTheme.primaryColor.lighter :FluTheme.primaryColor.dark
        }
    }

    Rectangle{
        id:dot
        width: dotSize
        height: dotSize
        FluShadow{
            radius: dotSize/2
        }
        radius: dotSize/2
        anchors.verticalCenter: isHorizontal ?  parent.verticalCenter : undefined
        anchors.horizontalCenter: isHorizontal ? undefined :parent.horizontalCenter
        color:FluTheme.isDark ? Qt.rgba(69/255,69/255,69/255,1) :Qt.rgba(1,1,1,1)
        Rectangle{
            width: dotSize/2
            height: dotSize/2
            radius: dotSize/4
            color:FluTheme.isDark ? FluTheme.primaryColor.lighter :FluTheme.primaryColor.dark
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
                axis: isHorizontal ? Drag.XAxis : Drag.YAxis
                minimumX: isHorizontal ? -dotSize/2 : 0
                maximumX: isHorizontal ?  (control.width - dotSize/2) : 0
                minimumY: isHorizontal ? 0 : -dotSize/2
                maximumY: isHorizontal ? 0 : (control.height - dotSize/2)
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
            y: isHorizontal ? -40 : 32
        }
    }

}

