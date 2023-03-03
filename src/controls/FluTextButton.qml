import QtQuick 2.15
import FluentUI 1.0

FluText {
    id:root
    color: {
        if(FluApp.isDark){
        return mouse_area.containsMouse?Qt.rgba(73/255,148/255,206/255,1):Qt.rgba(76/255,160/255,224/255,1)
        }
        return mouse_area.containsMouse?Qt.rgba(24/255,116/255,186/255,1):Qt.rgba(0/255,102/255,180/255,1)
    }
    signal clicked
    MouseArea{
        id:mouse_area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.clicked()
        }
    }
}
