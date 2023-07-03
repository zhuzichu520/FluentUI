import QtQuick
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Item {
    property string  headerText: "Titlte"
    property bool expand: false
    property int contentHeight : 300
    default property alias content: container.data
    id:control
    implicitHeight: Math.max((layout_header.height + container.height),layout_header.height)
    implicitWidth: 400
    Rectangle{
        id:layout_header
        width: parent.width
        height: 45
        radius: 4
        color: FluTheme.dark ? Window.active ? Qt.rgba(38/255,44/255,54/255,1) : Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
        border.color: FluTheme.dark ?  Window.active ? Qt.rgba(55/255,55/255,55/255,1) : Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
        MouseArea{
            id:control_mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                expand = !expand
            }
        }
        FluText{
            text: headerText
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 15
            }
        }
        FluIconButton{
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 15
            }
            color:{
                if(control_mouse.containsMouse || hovered){
                    return FluTheme.dark ? Qt.rgba(73/255,73/255,73/255,1) : Qt.rgba(245/255,245/255,245/255,1)
                }
                return FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
            }
            onClicked: {
                expand = !expand
            }
            contentItem: FluIcon{
                rotation: expand?0:180
                iconSource:FluentIcons.ChevronUp
                iconSize: 15
                Behavior on rotation {
                    NumberAnimation{
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
    Item{
        anchors{
            top: layout_header.bottom
            topMargin: -1
            left: layout_header.left
        }
        width: parent.width
        clip: true
        height: contentHeight+container.y
        Rectangle{
            id:container
            width: parent.width
            height: parent.height
            radius: 4
            color: FluTheme.dark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
            border.color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
            y: -contentHeight
            states: [
                State{
                    name:"expand"
                    when: control.expand
                    PropertyChanges {
                        target: container
                        y:0
                    }
                },
                State{
                    name:"collapsed"
                    when: !control.expand
                    PropertyChanges {
                        target: container
                        y:-contentHeight
                    }
                }
            ]
            transitions: [
                Transition {
                    to:"expand"
                    NumberAnimation {
                        properties: "y"
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                },
                Transition {
                    to:"collapsed"
                    NumberAnimation {
                        properties: "y"
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            ]
        }
    }
}
