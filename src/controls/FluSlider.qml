import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15

Item{

    enum Orientation  {
        Horizontal,
        Vertical
    }
    property int size: 180
    property int dotSize: 24
    property int value: 50
    property int maxValue: 100
    property int orientation: FluSlider.Horizontal
    property bool isHorizontal: orientation === FluSlider.Horizontal
    property bool enableTip : true
    property var onLineClickFunc
    signal pressed
    signal released

    id:root
    height: control.height
    width: control.width
    rotation: isHorizontal ? 0 : 180
    Component.onCompleted: {
        seek(0)
    }

    MouseArea{
        id:mouse_line
        anchors.centerIn: control
        width: isHorizontal ? control.width : 10
        height: isHorizontal ? 10 : control.height
        hoverEnabled: true
        onClicked:
            (mouse) => {
                var val;
                if(isHorizontal){
                    val = mouse.x*maxValue/control.width
                }else{
                    val = mouse.y*maxValue/control.height
                }
                if(onLineClickFunc){
                    onLineClickFunc(val)
                }else{
                    seek(val)
                }
            }
    }

    Rectangle {
        id: control
        width: isHorizontal ? size : 4
        height:  isHorizontal ? 4 : size
        radius: 2
        anchors.verticalCenter: parent.verticalCenter
        color:FluTheme.isDark ? Qt.rgba(162/255,162/255,162/255,1) : Qt.rgba(138/255,138/255,138/255,1)
        Rectangle{
            id:rect
            radius: 2.5
            width: isHorizontal ? control.width*(value/maxValue) : 5
            height: isHorizontal ?  5  : control.height*(value/maxValue)
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
            scale: control_mouse.containsMouse || mouse_line.containsMouse  ? 1.3 : 1
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
                if(enableTip){
                    tool_tip.visible  =  true
                }
                root.pressed()
            }

            onReleased: {
                tool_tip.visible  =  false
                root.released()
            }
        }

        FluTooltip{
            id:tool_tip
            text:String(root.value)
            y: isHorizontal ? -40 : 32
        }
    }

    function seek(val){
        if(isHorizontal){
            dot.x =val/maxValue*control.width - dotSize/2
            root.value = Qt.binding(function(){
                return (dot.x+dotSize/2)/control.width*maxValue
            })
        }else{
            dot.y =val/maxValue*control.height - dotSize/2
            root.value = Qt.binding(function(){
                return (dot.y+dotSize/2)/control.height*maxValue
            })
        }
    }

}

