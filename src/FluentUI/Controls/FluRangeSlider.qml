import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Controls.impl
import QtQuick.Templates as T
import FluentUI

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
        implicitWidth: 20
        implicitHeight: 20
        radius: width / 2
        color:FluTheme.dark ? Qt.rgba(69/255,69/255,69/255,1) :Qt.rgba(1,1,1,1)
        FluShadow{
            radius: 10
        }
        FluIcon{
            width: 10
            height: 10
            iconSource: FluentIcons.FullCircleMask
            iconSize: 10
            scale:{
                if(control.first.pressed){
                    return 0.9
                }
                return control.first.hovered ? 1.2 : 1
            }
            iconColor: FluTheme.primaryColor
            anchors.centerIn: parent
            Behavior on scale{
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
        implicitWidth: 20
        implicitHeight: 20
        radius: width / 2
        color:FluTheme.dark ? Qt.rgba(69/255,69/255,69/255,1) :Qt.rgba(1,1,1,1)
        FluShadow{
            radius: 10
        }
        FluIcon{
            width: 10
            height: 10
            iconSource: FluentIcons.FullCircleMask
            iconSize: 10
            scale:{
                if(control.second.pressed){
                    return 0.9
                }
                return control.second.hovered ? 1.2 : 1
            }
            iconColor: FluTheme.primaryColor
            anchors.centerIn: parent
            Behavior on scale{
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
            color: FluTheme.primaryColor
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
