import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

T.RangeSlider {
    id: control
    property bool tooltipEnabled: true
    property bool isTipInt: true
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            first.implicitHandleWidth + leftPadding + rightPadding,
                            second.implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             first.implicitHandleHeight + topPadding + bottomPadding,
                             second.implicitHandleHeight + topPadding + bottomPadding)
    padding: 6
    first.value: 0
    second.value: 100
    stepSize: 1
    from: 0
    to:100
    snapMode: RangeSlider.SnapAlways
    first.handle: Rectangle {
        x: control.leftPadding + (control.horizontal ? control.first.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.first.visualPosition * (control.availableHeight - height))
        implicitWidth: 24
        implicitHeight: 24
        radius: width / 2
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
                if(control.first.pressed){
                    return 4/10
                }
                return control.first.hovered ? 6/10 : 5/10
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

    second.handle: Rectangle {
        x: control.leftPadding + (control.horizontal ? control.second.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.second.visualPosition * (control.availableHeight - height))
        implicitWidth: 24
        implicitHeight: 24
        radius: width / 2
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
                if(control.second.pressed){
                    return 4/10
                }
                return control.second.hovered ? 6/10 : 5/10
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
        scale: control.horizontal && control.mirrored ? -1 : 1
        Rectangle{
            anchors.fill: parent
            anchors.margins: 1
            radius: 2
            color:FluTheme.dark ? Qt.rgba(162/255,162/255,162/255,1) : Qt.rgba(138/255,138/255,138/255,1)
        }
        Rectangle {
            x: control.horizontal ? control.first.position * parent.width + 3 : 0
            y: control.horizontal ? 0 : control.second.visualPosition * parent.height + 3
            width: control.horizontal ? control.second.position * parent.width - control.first.position * parent.width - 6 : 6
            height: control.horizontal ? 6 : control.second.position * parent.height - control.first.position * parent.height - 6
            color:FluTheme.dark ? FluTheme.primaryColor.lighter :FluTheme.primaryColor.dark
        }
    }
    FluTooltip{
        parent: control.first.handle
        visible: control.tooltipEnabled && (control.first.pressed || control.first.hovered)
        text:String(isTipInt?Math.round(control.first.value):control.first.value)
    }
    FluTooltip{
        parent: control.second.handle
        visible: control.tooltipEnabled && (control.second.pressed || control.second.hovered)
        text:String(isTipInt?Math.round(control.second.value):control.second.value)
    }
}

