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
            desc:"The latest FluentUI controls and styles for your applications."
            url:"https://github.com/zhuzichu520/FluentUI"
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
                GradientStop { position: 0.8; color: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(1,1,1,0) }
                GradientStop { position: 1.0; color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1) }
            }
        }
        FluText{
            text:"FluentUI Gallery"
            fontStyle: FluText.TitleLarge
            anchors{
                top: parent.top
                left: parent.left
                topMargin: 20
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
            height: 240
            model: model_header
            header: Item{height: 10;width: 10}
            footer: Item{height: 10;width: 10}
            ScrollBar.horizontal: FluScrollBar{
                id: scrollbar_header
            }
            clip: false
            delegate:Item{
                width: 220
                height: 240
                FluArea{
                    radius: 8
                    width: 200
                    height: 220
                    anchors.centerIn: parent
                    Rectangle{
                        anchors.fill: parent
                        radius: 8
                        color:{
                            if(FluTheme.dark){
                                if(item_mouse.containsMouse){
                                    return Qt.rgba(1,1,1,0.03)
                                }
                                return Qt.rgba(0,0,0,0)
                            }else{
                                if(item_mouse.containsMouse){
                                    return Qt.rgba(0,0,0,0.03)
                                }
                                return Qt.rgba(0,0,0,0)
                            }
                        }
                    }

                    ColumnLayout{
                        Image {
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            source: model.icon
                        }
                        FluText{
                            text: model.title
                            fontStyle: FluText.BodyLarge
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                        }
                        FluText{
                            text: model.desc
                            Layout.topMargin: 5
                            Layout.preferredWidth: 160
                            Layout.leftMargin: 20
                            color: FluColors.Grey100
                            font.pixelSize: 12
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    FluIcon{
                        iconSource: FluentIcons.OpenInNewWindow
                        iconSize: 15
                        anchors{
                            bottom: parent.bottom
                            right: parent.right
                            rightMargin: 10
                            bottomMargin: 10
                        }
                    }
                    MouseArea{
                        id:item_mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onWheel: {
                            if (wheel.angleDelta.y > 0) scrollbar_header.decrease()
                            else scrollbar_header.increase()
                        }
                        onClicked: {
                            Qt.openUrlExternally(model.url)
                        }
                    }
                }
            }
        }
    }

    ListModel{
        id:model_added
        ListElement{
            title:"TabView"
            icon:"qrc:/res/image/control/TabView.png"
            desc:"A control that displays a collection of tabs thatcan be used to display several documents."
        }
        ListElement{
            title:"MediaPlayer"
            icon:"qrc:/res/image/control/MediaPlayerElement.png"
            desc:"A control to display video and image content"
        }
    }

    ListModel{
        id:model_update
        ListElement{
            title:"Buttons"
            icon:"qrc:/res/image/control/Button.png"
             desc:"A control that responds to user input and raisesa Click event."
        }
        ListElement{
            title:"InfoBar"
            icon:"qrc:/res/image/control/InfoBar.png"
             desc:"An inline message to display app-wide statuschange information."
        }
        ListElement{
            title:"Slider"
            icon:"qrc:/res/image/control/Slider.png"
             desc:"A control that lets the user select from a rangeof values by moving a Thumb control along atrack."
        }
        ListElement{
            title:"CheckBox"
            icon:"qrc:/res/image/control/Checkbox.png"
             desc:"A control that a user can select or clear."
        }
    }

    Component{
        id:com_item
        Item{
            width: 320
            height: 120
            FluArea{
                radius: 8
                width: 300
                height: 100
                anchors.centerIn: parent
                Rectangle{
                    anchors.fill: parent
                    radius: 8
                    color:{
                        if(FluTheme.dark){
                            if(item_mouse.containsMouse){
                                return Qt.rgba(1,1,1,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }else{
                            if(item_mouse.containsMouse){
                                return Qt.rgba(0,0,0,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }
                    }
                }
                Image{
                    id:item_icon
                    height: 40
                    width: 40
                    source: model.icon
                    anchors{
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                }

                FluText{
                    id:item_title
                    text:model.title
                    fontStyle: FluText.Subtitle
                    anchors{
                        left: item_icon.right
                        leftMargin: 20
                        top: item_icon.top
                    }
                }

                FluText{
                    id:item_desc
                    text:model.desc
                    color:FluColors.Grey100
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    anchors{
                        left: item_title.left
                        right: parent.right
                        rightMargin: 20
                        top: item_title.bottom
                        topMargin: 5
                    }
                }

                MouseArea{
                    id:item_mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        rootwindow.startPageByTitle(model.title)
                    }
                }
            }
        }
    }

    FluText{
        text: "Recently added samples"
        fontStyle: FluText.TitleLarge
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }

    GridView{
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 120
        cellWidth: 320
        boundsBehavior: GridView.StopAtBounds
        model:model_added
        delegate: com_item
    }

    FluText{
        text: "Recently updated samples"
        fontStyle: FluText.TitleLarge
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }

    GridView{
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 120
        cellWidth: 320
        boundsBehavior: GridView.StopAtBounds
        model: model_update
        delegate: com_item
    }

}
