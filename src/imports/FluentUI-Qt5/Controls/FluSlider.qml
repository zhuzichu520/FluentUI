import QtQuick 2.12
import QtQuick.Templates 2.12 as T
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
        implicitWidth: 24
        implicitHeight: 24
        radius: 12
        color:FluTheme.dark ? Qt.rgba(69/255,69/255,69/255,1) :Qt.rgba(1,1,1,1)
        FluShadow{
            radius: 12
        }
        Rectangle{
            width: 24
            height: 24
            radius: 12
            color:FluTheme.dark ? FluTheme.primaryColor.lighter :FluTheme.primaryColor.dark
            anchors.centerIn: parent
            scale: {
                if(control.pressed){
                    return 4/10
                }
                return control.hovered ? 6/10 : 5/10
            }
            Behavior on scale {
                enabled: FluTheme.enableAnimation
                NumberAnimation{
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
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
            color:FluTheme.dark ? FluTheme.primaryColor.lighter :FluTheme.primaryColor.dark
        }
    }
    FluTooltip{
        parent: control.handle
        visible: control.tooltipEnabled && control.pressed
        text:String(control.value)
    }
}
