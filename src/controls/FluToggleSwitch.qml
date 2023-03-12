import QtQuick 2.0
import QtQuick.Controls 2.0
import FluentUI 1.0

Button {

    property bool selected: false
    property var clickFunc

    id: control
    width: 40
    implicitWidth: 40
    height: 20
    implicitHeight: 20
    focusPolicy:Qt.TabFocus
    Keys.onSpacePressed: control.visualFocus&&clicked()
    onClicked: {
        if(clickFunc){
            clickFunc()
            return
        }
        selected = !selected
    }
    background : Rectangle {
        width: control.width
        height: control.height
        radius: height / 2
        FluFocusRectangle{
            visible: control.visualFocus
            radius: 20
        }
        color: {
            if(FluTheme.isDark){
                if(selected){
                    return FluTheme.primaryColor.dark
                }
                if(hovered){
                    return "#3E3E3C"
                }
                return "#323232"
            }else{
                if(selected){
                    return FluTheme.primaryColor.dark
                }
                if(hovered){
                    return "#F4F4F4"
                }
                return  "#FFFFFF"
            }
        }
        border.width: 1
        border.color: selected ? Qt.lighter(FluTheme.primaryColor.dark,1.2) : "#666666"
        Rectangle {
            x:  selected ? control.implicitWidth  - width - 4 : 4
            width:  control.height - 8
            height: control.height - 8
            radius: width / 2
            scale: hovered ? 1.2 : 1.0
            anchors.verticalCenter: parent.verticalCenter
            color: selected ? "#FFFFFF" : "#666666"
            Behavior on x {
                NumberAnimation { duration: 200 }
            }
        }
    }

}
