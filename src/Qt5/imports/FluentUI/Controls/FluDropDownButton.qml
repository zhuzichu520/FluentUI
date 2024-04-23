import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FluentUI 1.0

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
    Item{
        id: d
        property var window: Window.window
    }
    onClicked: {
        if(menu.count !==0){
            var pos = control.mapToItem(null, 0, 0)
            var containerHeight = menu.count*36
            if(d.window.height>pos.y+control.height+containerHeight){
                menu.y = control.height
            }else if(pos.y>containerHeight){
                menu.y = -containerHeight
            }else{
                menu.y = d.window.height-(pos.y+containerHeight)
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
