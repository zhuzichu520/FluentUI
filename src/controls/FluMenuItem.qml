import QtQuick
import QtQuick.Controls

Item {

    id:root
    width: {
        if(root.parent){
            return root.parent.width
        }
        return 140
    }
    height: 32

    property string text: "MenuItem"
    signal clicked

    Rectangle{
        anchors.centerIn: parent
        width: root.width-40
        height: 32
        radius: 4
        color:{
            if(FluTheme.isDark){
                if(mouse_area.containsMouse){
                    return Qt.rgba(1,1,1,0.05)
                }
                return Qt.rgba(0,0,0,0)
            }else{
                if(mouse_area.containsMouse){
                    return Qt.rgba(0,0,0,0.05)
                }
                return Qt.rgba(0,0,0,0)
            }
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
