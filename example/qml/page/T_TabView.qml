import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    property var colors : [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]

    title: qsTr("TabView")

    Component{
        id:com_page
        Rectangle{
            anchors.fill: parent
            color: argument.normal
        }
    }

    function newTab(){
        tab_view.appendTab("qrc:/example/res/image/favicon.ico",qsTr("Document ")+tab_view.count(),com_page,colors[Math.floor(Math.random() * 8)])
    }

    Component.onCompleted: {
        newTab()
        newTab()
        newTab()
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        padding: 10
        RowLayout{
            spacing: 14
            FluCopyableText{
                text: qsTr("Tab Width Behavior:")
            }
            FluDropDownButton{
                id:btn_tab_width_behavior
                Layout.preferredWidth: 140
                text:  qsTr("Equal")
                FluMenuItem{
                    text: qsTr("Equal")
                    onClicked: {
                        btn_tab_width_behavior.text = text
                        tab_view.tabWidthBehavior = FluTabViewType.Equal
                    }
                }
                FluMenuItem{
                    text: qsTr("SizeToContent")
                    onClicked: {
                        btn_tab_width_behavior.text = text
                        tab_view.tabWidthBehavior = FluTabViewType.SizeToContent
                    }
                }
                FluMenuItem{
                    text: qsTr("Compact")
                    onClicked: {
                        btn_tab_width_behavior.text = text
                        tab_view.tabWidthBehavior = FluTabViewType.Compact
                    }
                }
            }
            FluCopyableText{
                text: qsTr("Tab Close Button Visibility:")
            }
            FluDropDownButton{
                id:btn_close_button_visibility
                text: qsTr("Always")
                Layout.preferredWidth: 120
                FluMenuItem{
                    text: qsTr("Never")
                    onClicked: {
                        btn_close_button_visibility.text = text
                        tab_view.closeButtonVisibility = FluTabViewType.Never
                    }
                }
                FluMenuItem{
                    text: qsTr("Always")
                    onClicked: {
                        btn_close_button_visibility.text = text
                        tab_view.closeButtonVisibility = FluTabViewType.Always
                    }
                }
                FluMenuItem{
                    text: qsTr("OnHover")
                    onClicked: {
                        btn_close_button_visibility.text = text
                        tab_view.closeButtonVisibility = FluTabViewType.OnHover
                    }
                }
            }
        }
    }

    FluFrame{
        Layout.fillWidth: true
        Layout.topMargin: 15
        Layout.preferredHeight: 400
        padding: 10
        FluTabView{
            id:tab_view
            onNewPressed:{
                newTab()
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -6
        code:'FluTabView{
    anchors.fill: parent
    Component.onCompleted: {
        newTab()
        newTab()
        newTab()
    }
    Component{
        id:com_page
        Rectangle{
            anchors.fill: parent
            color: argument
        }
    }
    function newTab(){
        tab_view.appendTab("qrc:/example/res/image/favicon.ico","Document 1",com_page,argument)
    }
}
'
    }
}
