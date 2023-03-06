import QtQuick 2.15
import FluentUI 1.0

FluText {
    id:root
    color: {
        if(FluTheme.isDark){
        return mouse_area.containsMouse?Qt.darker(FluTheme.primaryColor.lighter,1.1):FluTheme.primaryColor.lighter
        }
        return mouse_area.containsMouse?Qt.lighter(FluTheme.primaryColor.dark,1.1):FluTheme.primaryColor.dark
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
