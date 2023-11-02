import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.impl
import QtQuick.Templates as T
import FluentUI

T.MenuItem {
    property Component iconDelegate : com_icon
    property int iconSpacing: 5
    property int iconSource
    property int iconSize: 16
    property color textColor: {
        if(FluTheme.dark){
            if(!enabled){
                return Qt.rgba(131/255,131/255,131/255,1)
            }
            if(pressed){
                return Qt.rgba(162/255,162/255,162/255,1)
            }
            return Qt.rgba(1,1,1,1)
        }else{
            if(!enabled){
                return Qt.rgba(160/255,160/255,160/255,1)
            }
            if(pressed){
                return Qt.rgba(96/255,96/255,96/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }
    }
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
    Component{
        id:com_icon
        FluIcon{
            id:content_icon
            iconSize: control.iconSize
            iconSource:control.iconSource
        }
    }
    contentItem: Item{
        Row{
            spacing: control.iconSpacing
            readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
            readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: (!control.mirrored ? indicatorPadding : arrowPadding)+5
                right: parent.right
                rightMargin: (control.mirrored ? indicatorPadding : arrowPadding)+5
            }
            FluLoader{
                id:loader_icon
                sourceComponent: iconDelegate
                anchors.verticalCenter: parent.verticalCenter
                visible: status === Loader.Ready
            }
            FluText {
                id:content_text
                text: control.text
                color: control.textColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
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
    background: Item {
        implicitWidth: 150
        implicitHeight: 36
        x: 1
        y: 1
        width: control.width - 2
        height: control.height - 2
        Rectangle{
            anchors.fill: parent
            anchors.margins: 3
            radius: 4
            color:{
                if(control.highlighted){
                    return FluTheme.itemCheckColor
                }
                return FluTheme.itemNormalColor
            }
        }
    }
}
