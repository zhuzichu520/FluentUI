import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

Item {
    property string text: "MenuItem"
    property var onClickFunc
    signal clicked
    id:control
    width: {
        if(control.parent){
            return control.parent.width
        }
        return 140
    }
    height: 32
    Rectangle{
        anchors.centerIn: parent
        width: control.width-40
        height: 32
        radius: 4
        color:{
            if(FluTheme.dark){
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
            text: control.text
            anchors.centerIn: parent
        }
        MouseArea{
            id:mouse_area
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                if(control.onClickFunc){
                    control.onClickFunc()
                    return
                }
                control.parent.closePopup()
                control.clicked()
            }
        }
    }
}
