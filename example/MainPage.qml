import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

import FluentUI 1.0

FluWindow {
    id:rootwindow
    width: 800
    height: 600
    title: "FluentUI"
    minimumWidth: 500
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
            title:"Rectangle"
            onTap:{
                nav_view.push("qrc:/T_Rectangle.qml")
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

        FluPaneItemHeader{
            title:"Navigation"
        }

        FluPaneItem{
            title:"TreeView"
            onTap:{
                nav_view.push("qrc:/T_TreeView.qml")
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
                FluApp.navigate("/About")
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

        Component.onCompleted: {
            nav_view.setCurrentIndex(1)
            nav_view.push("qrc:/T_Buttons.qml")
        }


    }


}
