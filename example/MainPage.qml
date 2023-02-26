import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Rectangle {
    id:rootwindow
    width: 800
    height: 600
    color : "#F3F3F3"

    ListModel{
        id:nav_items
        ListElement{
            text:"Controls"
            page:"qrc:/T_Controls.qml"
        }
        ListElement{
            text:"Typography"
            page:"qrc:/T_Typography.qml"
        }
    }

    ListView{
        id:nav_list
        anchors{
            top: parent.top
            bottom: parent.bottom
            topMargin: 20
            bottomMargin: 20
        }
        width: 160
        model: nav_items
        delegate: Item{
            height: 38
            width: nav_list.width

            Rectangle{
                color: {
                    if(nav_list.currentIndex === index){
                        return "#EAEAEB"
                    }
                    return item_mouse.containsMouse? "#EAEAEA" : "#00000000"
                }
                radius: 4
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 2
                    bottomMargin: 2
                    leftMargin: 6
                    rightMargin: 6
                }
            }

            MouseArea{
                id:item_mouse
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    nav_list.currentIndex = index
                }
            }

            Text{
                text:model.text
                anchors.centerIn: parent
            }

        }
    }

    Rectangle{
        color: "#FFFFFF"
        radius: 10
        clip: true
        anchors{
            left: nav_list.right
            leftMargin: 2
            top: parent.top
            topMargin: 20
            right: parent.right
            rightMargin: 10
            bottom: parent.bottom
            bottomMargin: 20
        }
        border.width: 1
        border.color: "#EEEEEE"

        Loader{
            anchors.fill: parent
            anchors.margins:20
            source: nav_items.get(nav_list.currentIndex).page
        }

    }

}
