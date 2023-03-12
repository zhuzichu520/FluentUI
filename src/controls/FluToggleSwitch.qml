import QtQuick 2.0
import QtQuick.Controls 2.0
import FluentUI 1.0

Button {
    id: root
    width: 40
    implicitWidth: 40
    height: 20
    implicitHeight: 20
    checkable: true
    background : Rectangle {
        width: root.width
        height: root.height
        radius: height / 2
        FluFocusRectangle{
            visible: root.visualFocus
            radius: 20
        }
        color: {
            if(FluTheme.isDark){
                if(checked){
                    return FluTheme.primaryColor.dark
                }
                if(hovered){
                    return "#3E3E3C"
                }
                return "#323232"
            }else{
                if(checked){
                    return FluTheme.primaryColor.dark
                }
                if(hovered){
                    return "#F4F4F4"
                }
                return  "#FFFFFF"
            }
        }
        border.width: 1
        border.color: checked ? Qt.lighter(FluTheme.primaryColor.dark,1.2) : "#666666"
        Rectangle {
            x:  checked ? root.implicitWidth  - width - 4 : 4
            width:  root.height - 8
            height: root.height - 8
            radius: width / 2
            scale: hovered ? 1.2 : 1.0
            anchors.verticalCenter: parent.verticalCenter
            color: checked ? "#FFFFFF" : "#666666"
            Behavior on x {
                NumberAnimation { duration: 200 }
            }
        }
    }
}
