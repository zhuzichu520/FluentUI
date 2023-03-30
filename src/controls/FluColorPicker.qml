import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI


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
            return FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
        }
        border.width: 1
    }
    contentItem: Item{}
    onClicked: {
        popup.showPopup()
    }
    Menu{
        id:popup
        modal: true
        dim:false
        height: container.height
        width: container.width
        contentItem: Item{
            anchors.fill: parent
            FluColorView{
                id:container
            }
        }
        background:Item{}
        enter: Transition {
            NumberAnimation {
                property: "y"
                from:0
                to:popup.y
                duration: 150
            }
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: 150
            }
        }
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
