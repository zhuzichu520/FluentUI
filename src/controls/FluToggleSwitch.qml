import QtQuick 2.0
import QtQuick.Controls 2.0
import FluentUI 1.0
import QtQuick.Layouts 1.15

Button {

    property bool selected: false
    property var clickFunc

    id: control
    height: 20
    implicitHeight: height
    focusPolicy:Qt.TabFocus
    Keys.onSpacePressed: control.visualFocus&&clicked()
    onClicked: {
        if(clickFunc){
            clickFunc()
            return
        }
        selected = !selected
    }

    contentItem: Item{}

    background : RowLayout{
        spacing: 0
        Rectangle {
            id:control_backgound
            width: 40
            height: control.height
            radius: height / 2
            smooth: true
            antialiasing: true
            FluFocusRectangle{
                visible: control.visualFocus
                radius: 20
            }
            color: {
                if(FluTheme.dark){
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
                x:  selected ? control_backgound.width  - width - 4 : 4
                width:  control.height - 8
                height: control.height - 8
                radius: width / 2
                antialiasing: true
                scale: hovered ? 1.2 : 1.0
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
                color: selected ? "#FFFFFF" : "#666666"
                Behavior on x {
                    NumberAnimation { duration: 200 }
                }
                Behavior on scale {
                    NumberAnimation { duration: 150 }
                }
            }
        }

        FluText{
            text: control.text
            Layout.leftMargin: 5
            visible: text !== ""
        }

    }

}
