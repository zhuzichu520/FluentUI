import QtQuick 2.15
import QtQuick.Controls 2.15

Item {

    id:root
    width: 140
    height: 32

    property string text: "MenuItem"
    signal clicked

    Rectangle{
        anchors.centerIn: parent
        width: 100
        height: 32
        radius: 4
        color:{
            if(mouse_area.containsMouse){
                return FluApp.isDark ? Qt.rgba(56/255,56/255,56/255,1) : Qt.rgba(230/255,230/255,230/255,1)
            }
            return FluApp.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(237/255,237/255,237/255,1)
        }

        FluText{
            text: root.text
            anchors.centerIn: parent
        }

        MouseArea{
            id:mouse_area
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                root.clicked()
                root.parent.closePopup()
            }
        }
    }
}
