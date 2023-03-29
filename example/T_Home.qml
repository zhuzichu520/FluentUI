import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluScrollablePage{


    leftPadding:10
    rightPadding:0
    bottomPadding:20

    ListModel{
        id:model_header
        ListElement{
            icon:"qrc:/res/image/ic_home_github.png"
            title:"FluentUI GitHub"
            desc:"The latest Windows nativecontrols and styles for your applications."
        }

    }

    Item{
        Layout.fillWidth: true
        height: 320
        Image {
            fillMode:Image.PreserveAspectCrop
            anchors.fill: parent
            verticalAlignment: Qt.AlignTop
            source: "qrc:/res/image/bg_home_header.png"
        }
        Rectangle{
            anchors.fill: parent
            gradient: Gradient{
                GradientStop { position: 0.8; color: FluTheme.isDark ? Qt.rgba(0,0,0,0) : Qt.rgba(1,1,1,0) }
                GradientStop { position: 1.0; color: FluTheme.isDark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1) }
            }
        }
        FluText{
            text:"FluentUI Gallery"
            fontStyle: FluText.TitleLarge
            anchors{
                top: parent.top
                left: parent.left
                topMargin: 60
                leftMargin: 20
            }
        }

        ListView{
            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            orientation: ListView.Horizontal
            boundsBehavior: ListView.StopAtBounds
            height: 200
            model: model_header
            header: Item{height: 10;width: 10}
            footer: Item{height: 10;width: 10}
            ScrollBar.horizontal: FluScrollBar{
                id: scrollbar_header
            }
            clip: false
            delegate:Item{
                width: 180
                height: 200
                FluArea{
                    radius: 8
                    width: 160
                    height: 180
                    anchors.centerIn: parent
                    color:{
                        if(item_mouse.containsMouse){
                            return FluTheme.dark ? Qt.lighter(Qt.rgba(0,0,0,1),1.05)  : Qt.darker(Qt.rgba(1,1,1,1),1.05)
                        }
                        return FluTheme.dark ? Qt.rgba(0,0,0,0.98)  : Qt.rgba(1,1,1,0.98)
                    }
                    MouseArea{
                        id:item_mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onWheel: {
                            if (wheel.angleDelta.y > 0) scrollbar_header.decrease()
                            else scrollbar_header.increase()
                        }
                    }
                }
            }
        }


    }


}
