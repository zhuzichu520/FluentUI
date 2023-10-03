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
    property alias colorValue: container.colorValue
    property alias enableAlphaChannel: container.enableAlphaChannel
    background:
        Rectangle{
        id:layout_color
        radius: 5
        color:"#00000000"
        border.color: {
            if(hovered)
                return FluTheme.primaryColor.light
            return FluTheme.dark ? Qt.rgba(100/255,100/255,100/255,1) : Qt.rgba(200/255,200/255,200/255,1)
        }
        border.width: 1

        Rectangle{
            anchors.fill: parent
            anchors.margins: 4
            radius: 5
            color: control.colorValue
        }

    }
    Item{
        id: d
        property var window : Window.window
    }
    contentItem: Item{}
    onClicked: {
        popup.showPopup()
    }
    Menu{
        id:popup
        modal: true
        Overlay.modal: Item {}
        height: container.height
        width: container.width
        contentItem: Item{
            clip: true
            FluColorView{
                id:container
            }
        }
        background:Item{
            FluShadow{
                radius: 5
            }
        }
        enter: Transition {
            reversible: true
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: FluTheme.enableAnimation ? 83 : 0
            }
        }

        exit:Transition {
            NumberAnimation {
                property: "opacity"
                from:1
                to:0
                duration: FluTheme.enableAnimation ? 83 : 0
            }
        }
        function showPopup() {
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height>pos.y+control.height+container.height){
                popup.y = control.height
            } else if(pos.y>container.height){
                popup.y = -container.height
            } else {
                popup.y = d.window.height-(pos.y+container.height)
            }
            popup.x = -(popup.width-control.width)/2
            popup.open()
        }
    }
    function setColor(color){
        container.setColor(color)
    }
}
