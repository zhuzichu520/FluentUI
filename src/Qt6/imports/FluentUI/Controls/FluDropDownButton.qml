import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Window
import FluentUI

FluButton {
    id: control
    default property alias contentData: menu.contentData
    rightPadding:35
    verticalPadding: 0
    horizontalPadding:12
    FluIcon{
        iconSource:FluentIcons.ChevronDown
        iconSize: 15
        anchors{
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        iconColor:control.textColor
    }
    onClicked: {
        if(menu.count !==0){
            var pos = control.mapToItem(null, 0, 0)
            var containerHeight = menu.count*36
            if(window.height>pos.y+control.height+containerHeight){
                menu.y = control.height
            }else if(pos.y>containerHeight){
                menu.y = -containerHeight
            }else{
                menu.y = window.height-(pos.y+containerHeight)
            }
            menu.open()
        }
    }
    FluMenu{
        id:menu
        modal:true
        width: control.width
    }
}
