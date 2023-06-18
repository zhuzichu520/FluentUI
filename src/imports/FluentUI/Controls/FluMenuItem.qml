import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Templates as T
import FluentUI

T.MenuItem {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: 6
    spacing: 6

    icon.width: 24
    icon.height: 24
    icon.color: control.palette.windowText

    height: visible ? implicitHeight : 0

    contentItem: FluText {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
        leftPadding: !control.mirrored ? indicatorPadding : arrowPadding
        rightPadding: control.mirrored ? indicatorPadding : arrowPadding
        verticalAlignment: Text.AlignVCenter
        text: control.text
    }

    indicator: FluIcon {
        x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        visible: control.checked
        iconSource: FluentIcons.CheckMark
    }

    arrow: FluIcon {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        visible: control.subMenu
        iconSource: FluentIcons.ChevronRightMed
    }

    background: Rectangle {
        implicitWidth: 150
        implicitHeight: 40
        x: 1
        y: 1
        width: control.width - 2
        height: control.height - 2
        color:{
            if(FluTheme.dark){
                if(control.highlighted){
                    return Qt.rgba(1,1,1,0.06)
                }
                return Qt.rgba(0,0,0,0)
            }else{
                if(control.highlighted){
                    return Qt.rgba(0,0,0,0.03)
                }
                return Qt.rgba(0,0,0,0)
            }
        }
    }
}
