import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0


Button{
    id:control
    width: 36
    height: 36
    implicitWidth: width
    implicitHeight: height
    background:
        Rectangle{
        id:layout_color
        radius: 5
        color: container.colorValue
        border.color: {
            if(hovered)
                return FluTheme.primaryColor.light
            return FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
        }
        border.width: 1
    }
    contentItem: Item{}
    onClicked: {
        popup.showPopup()
    }
    Popup{
        id:popup
        height: container.height
        width: container.width
        background: FluColorView{
            id:container
        }
        contentItem: Item{}
        function showPopup() {
            var pos = control.mapToItem(null, 0, 0)
            if(window.height>pos.y+control.height+popup.height){
                popup.y = control.height
            } else if(pos.y>popup.height){
                popup.y = -popup.height
            } else {
                popup.y = window.height-(pos.y+popup.height)
            }
            popup.x = -(popup.width-control.width)/2
            popup.open()
        }
    }

}
