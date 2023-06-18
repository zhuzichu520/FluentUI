import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import FluentUI

T.MenuBarItem {
    id: control

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
    }

    background: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: 3
        color: {
            if(FluTheme.dark){
                if(control.highlighted){
                    return Qt.rgba(1,1,1,0.06)
                }
                if(control.hovered){
                    return Qt.rgba(1,1,1,0.03)
                }
                return Qt.rgba(0,0,0,0)
            }else{
                if(control.highlighted){
                    return Qt.rgba(0,0,0,0.06)
                }
                if(control.hovered){
                    return Qt.rgba(0,0,0,0.03)
                }
                return Qt.rgba(0,0,0,0)
            }
        }
    }
}
