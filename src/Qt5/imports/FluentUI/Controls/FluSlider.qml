import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

T.Slider {
    property bool tooltipEnabled: true
    id: control
    to:100
    stepSize:1
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)
    padding: 6
    handle: Rectangle {
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        implicitWidth: 20
        implicitHeight: 20
        radius: 10
        color:FluTheme.dark ? Qt.rgba(69/255,69/255,69/255,1) :Qt.rgba(1,1,1,1)
        FluShadow{
            radius: 10
        }
        FluIcon{
            width: 10
            height: 10
            Behavior on scale{
                NumberAnimation{
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
            iconSource: FluentIcons.FullCircleMask
            iconSize: 10
            scale:{
                if(control.pressed){
                    return 0.9
                }
                return control.hovered ? 1.2 : 1
            }
            iconColor: FluTheme.primaryColor
            anchors.centerIn: parent
        }
    }
    background: Item {
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        implicitWidth: control.horizontal ? 180 : 6
        implicitHeight: control.horizontal ? 6 : 180
        width: control.horizontal ? control.availableWidth : implicitWidth
        height: control.horizontal ? implicitHeight : control.availableHeight
        Rectangle{
            anchors.fill: parent
            anchors.margins: 1
            radius: 2
            color:FluTheme.dark ? Qt.rgba(162/255,162/255,162/255,1) : Qt.rgba(138/255,138/255,138/255,1)
        }
        scale: control.horizontal && control.mirrored ? -1 : 1
        Rectangle {
            y: control.horizontal ? 0 : control.visualPosition * parent.height
            width: control.horizontal ? control.position * parent.width : 6
            height: control.horizontal ? 6 : control.position * parent.height
            radius: 3
            color: FluTheme.primaryColor
        }
    }
    FluTooltip{
        parent: control.handle
        visible: control.tooltipEnabled && (control.pressed || control.hovered)
        text:String(control.value)
    }
}
