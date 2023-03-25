import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

import FluentUI

FluWindow {
    id:rootwindow
    width: 860
    height: 600
    title: "FluentUI"
    minimumWidth: 520
    minimumHeight: 400

    FluAppBar{
        id:appbar
        title: "FluentUI"
    }

    FluObject{
        id:original_items

        FluPaneItemHeader{
            title:"Inputs"
        }

        FluPaneItem{
            title:"Buttons"
            onTap:{
                nav_view.push("qrc:/T_Buttons.qml")
            }
        }

        FluPaneItem{
            title:"Slider"
            onTap:{
                nav_view.push("qrc:/T_Slider.qml")
            }
        }

        FluPaneItem{
            title:"ToggleSwitch"
            onTap:{
                nav_view.push("qrc:/T_ToggleSwitch.qml")
            }
        }

        FluPaneItemHeader{
            title:"Form"
        }

        FluPaneItem{
            title:"TextBox"
            onTap:{
                nav_view.push("qrc:/T_TextBox.qml")
            }
        }

        FluPaneItem{
            title:"TimePicker"
            onTap:{
                nav_view.push("qrc:/T_TimePicker.qml")
            }
        }

        FluPaneItem{
            title:"DatePicker"
            onTap:{
                nav_view.push("qrc:/T_DatePicker.qml")
            }
        }

        FluPaneItem{
            title:"CalendarPicker"
            onTap:{
                nav_view.push("qrc:/T_CalendarPicker.qml")
            }
        }

        FluPaneItem{
            title:"ColorPicker"
            onTap:{
                nav_view.push("qrc:/T_ColorPicker.qml")
            }
        }

        FluPaneItemHeader{
            title:"Surface"
        }

        FluPaneItem{
            title:"InfoBar"
            onTap:{
                nav_view.push("qrc:/T_InfoBar.qml")
            }
        }

        FluPaneItem{
            title:"Progress"
            onTap:{
                nav_view.push("qrc:/T_Progress.qml")
            }
        }

        FluPaneItem{
            title:"Badge"
            onTap:{
                nav_view.push("qrc:/T_Badge.qml")
            }
        }

        FluPaneItem{
            title:"Rectangle"
            onTap:{
                nav_view.push("qrc:/T_Rectangle.qml")
            }
        }

        FluPaneItem{
            title:"Carousel"
            onTap:{
                nav_view.push("qrc:/T_Carousel.qml")
            }
        }

        FluPaneItem{
            title:"Expander"
            onTap:{
                nav_view.push("qrc:/T_Expander.qml")
            }
        }

        FluPaneItemHeader{
            title:"Popus"
        }

        FluPaneItem{
            title:"Dialog"
            onTap:{
                nav_view.push("qrc:/T_Dialog.qml")
            }
        }

        FluPaneItem{
            title:"Tooltip"
            onTap:{
                nav_view.push("qrc:/T_Tooltip.qml")
            }
        }

        FluPaneItem{
            title:"Menu"
            onTap:{
                nav_view.push("qrc:/T_Menu.qml")
            }
        }

        FluPaneItemHeader{
            title:"Navigation"
        }

        FluPaneItem{
            title:"TreeView"
            onTap:{
                nav_view.push("qrc:/T_TreeView.qml")
            }
        }


        FluPaneItem{
            title:"MultiWindow"
            onTap:{
                nav_view.push("qrc:/T_MultiWindow.qml")
            }
        }

        FluPaneItemHeader{
            title:"Theming"
        }

        FluPaneItem{
            title:"Theme"
            onTap:{
                nav_view.push("qrc:/T_Theme.qml")
            }
        }

        FluPaneItem{
            title:"Awesome"
            onTap:{
                nav_view.push("qrc:/T_Awesome.qml")
            }
        }
        FluPaneItem{
            title:"Typography"
            onTap:{
                nav_view.push("qrc:/T_Typography.qml")
            }
        }

        FluPaneItemHeader{
            title:"Media"
        }

        FluPaneItem{
            title:"MediaPlayer"
            onTap:{
                nav_view.push("qrc:/T_MediaPlayer.qml")
            }
        }

    }

    FluObject{
        id:footer_items
        FluPaneItemSeparator{}
        FluPaneItem{
            title:"意见反馈"
            onTap:{
                Qt.openUrlExternally("https://github.com/zhuzichu520/FluentUI/issues/new")
            }
        }
        FluPaneItem{
            title:"关于"
            onTap:{
                FluApp.navigate("/about")
            }
        }
    }


    FluNavigationView{
        id:nav_view
        anchors{
            top: appbar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        items:original_items
        footerItems:footer_items

        actions:[
            Image {
                width: 30
                height: 30
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceSize: Qt.size(60,60)
                source: "qrc:/res/image/logo_openai.png"
                Layout.rightMargin: 5
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        FluApp.navigate("/chat")
                    }
                }
            },
            FluText{
                text:"夜间模式"
                fontStyle: FluText.Body
            },
            FluToggleSwitch{
                selected: FluTheme.isDark
                clickFunc:function(){
                    FluTheme.isDark = !FluTheme.isDark
                }
            }
        ]

        Component.onCompleted: {
            nav_view.setCurrentIndex(1)
            nav_view.push("qrc:/T_Buttons.qml")
        }


    }


}
