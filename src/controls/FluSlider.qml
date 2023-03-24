import QtQuick
import QtQuick.Controls

Item{

    id:root

    property int size: 180
    property int dotSize: 24

    property int value: 50

    property int maxValue: 100


    enum Orientation  {
        Horizontal,
        Vertical
    }

    height: control.height
    width: control.width

    property int orientation: FluSlider.Horizontal

    property bool isHorizontal: orientation === FluSlider.Horizontal

    property bool enableTip : true

    signal pressed
    signal released

    rotation: isHorizontal ? 0 : 180

    Component.onCompleted: {
        seek(0)
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

    function seek(position){
        if(isHorizontal){
            dot.x =position/maxValue*control.width - dotSize/2
            root.value = Qt.binding(function(){
                return (dot.x+dotSize/2)/control.width*maxValue
            })
        }else{
            dot.y =position/maxValue*control.height - dotSize/2
            root.value = Qt.binding(function(){
                return (dot.y+dotSize/2)/control.height*maxValue
            })
        }
    }

}

