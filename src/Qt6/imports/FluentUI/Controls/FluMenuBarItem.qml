import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import FluentUI

T.MenuBarItem {
    property bool disabled: false
    property color textColor: {
        if(FluTheme.dark){
            if(disabled){
                return Qt.rgba(131/255,131/255,131/255,1)
            }
            if(pressed){
                return Qt.rgba(162/255,162/255,162/255,1)
            }
            return Qt.rgba(1,1,1,1)
        }else{
            if(disabled){
                return Qt.rgba(160/255,160/255,160/255,1)
            }
            if(pressed){
                return Qt.rgba(96/255,96/255,96/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }
    }
    id: control
    enabled: !disabled
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    spacing: 6
    padding: 6
    leftPadding: 12
    rightPadding: 16
    icon.width: 24
    icon.height: 24
    icon.color: control.palette.buttonText
    contentItem: FluText {
        verticalAlignment: Text.AlignVCenter
        text: control.text
        color:control.textColor
    }
    background: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: 3
        color: {
            if(control.highlighted){
                return FluTheme.itemHoverColor
            }
            return FluTheme.itemNormalColor
        }
    }
}

