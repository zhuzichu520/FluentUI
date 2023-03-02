import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

import FluentUI 1.0

FluWindow {
    id:rootwindow
    width: 800
    height: 700
    title: "FluentUI"
    minimumWidth: 600
    minimumHeight: 500

    FluAppBar{
        id:appbar
        title: "FluentUI"
    }

    Item{
        id:data

        ListModel{
            id:nav_items
            ListElement{
                text:"Buttons"
                page:"qrc:/T_Buttons.qml"
            }
            ListElement{
                text:"TextBox"
                page:"qrc:/T_TextBox.qml"
            }
            ListElement{
                text:"ToggleSwitch"
                page:"qrc:/T_ToggleSwitch.qml"
            }
            ListElement{
                text:"Slider"
                page:"qrc:/T_Slider.qml"
            }
            ListElement{
                text:"InfoBar"
                page:"qrc:/T_InfoBar.qml"
            }
            ListElement{
                text:"Progress"
                page:"qrc:/T_Progress.qml"
            }
            ListElement{
                text:"Rectangle"
                page:"qrc:/T_Rectangle.qml"
            }
            ListElement{
                text:"Awesome"
                page:"qrc:/T_Awesome.qml"
            }
            ListElement{
                text:"Typography"
                page:"qrc:/T_Typography.qml"
            }
        }
    }

    FluIconButton{
        icon:FluentIcons.FA_navicon
        anchors{
            left: parent.left
            bottom: parent.bottom
            leftMargin: 12
            bottomMargin: 12
        }
        FluMenu{
            id:menu
            x:40
            margins:4
            FluMenuItem{
                text:"关于"
                onClicked:{
                    FluApp.navigate("/About")
                }
            }
            FluMenuItem{
                text:"设置"
                onClicked:{
                    FluApp.navigate("/Setting")
                }
            }
        }
        onClicked:{
            menu.open()
        }
    }

    ListView{
        id:nav_list
        anchors{
            top: appbar.bottom
            bottom: parent.bottom
            topMargin: 20
            bottomMargin: 52
        }
        clip: true
        width: 160
        model: nav_items
        delegate: Item{
            height: 38
            width: nav_list.width

            Rectangle{
                color: {
                    if(FluApp.isDark){
                        if(item_mouse.containsMouse){
                            return "#292929"
                        }
                        if(nav_list.currentIndex === index){
                            return "#2D2D2D"
                        }
                        return "#00000000"
                    }else{
                        if(item_mouse.containsMouse){
                            return "#EDEDED"
                        }
                        if(nav_list.currentIndex === index){
                            return "#EAEAEA"
                        }
                        return "#00000000"
                    }
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

            FluText{
                text:model.text
                anchors.centerIn: parent
                fontStyle: FluText.Caption
            }

        }
    }

    Rectangle{
        color: FluApp.isDark ? "#323232" : "#FFFFFF"
        radius: 10
        clip: true
        anchors{
            left: nav_list.right
            leftMargin: 2
            top: appbar.bottom
            topMargin: 20
            right: parent.right
            rightMargin: 10
            bottom: parent.bottom
            bottomMargin: 20
        }
        border.width: 1
        border.color: FluApp.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(238/255,238/255,238/255,1)

        Loader{
            anchors.fill: parent
            anchors.margins:20
            source: nav_items.get(nav_list.currentIndex).page
        }

    }

}
