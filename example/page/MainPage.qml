import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

import FluentUI 1.0

FluWindow {
    id:rootwindow
    width: 860
    height: 640
    title: "FluentUI"
    minimumWidth: 520
    minimumHeight: 400

    FluAppBar{
        id:appbar
        z:10
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
            title:"TabView"
            onTap:{
                nav_view.push("qrc:/T_TabView.qml")
            }
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
        anchors.fill: parent
        items: original_items
        footerItems:footer_items
        logo: "qrc:/res/image/favicon.ico"
        z: 11
        Component.onCompleted: {
            nav_view.setCurrentIndex(1)
            nav_view.push("qrc:/T_Buttons.qml")
        }


    }


}
