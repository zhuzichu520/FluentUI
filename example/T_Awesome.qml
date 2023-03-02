import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

Item {

    FluText{
        id:title
        text:"Awesome"
        fontStyle: FluText.TitleLarge
    }

    FluTextBox{
        id:text_box
        placeholderText: "请输入关键字"
        anchors{
            topMargin: 20
            top:title.bottom
        }
    }

    FluFilledButton{
        text:"搜索"
        anchors{
            left: text_box.right
            verticalCenter: text_box.verticalCenter
            leftMargin: 14
        }
        onClicked: {
            grid_view.model = FluApp.awesomelist(text_box.text)
        }
    }

    GridView{
        id:grid_view
        cellWidth: 120
        cellHeight: 60
        clip: true
        model:FluApp.awesomelist()
        ScrollBar.vertical: FluScrollBar {}
        anchors{
            topMargin: 10
            top:text_box.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: Item {

            width: 120
            height: 60

            FluIconButton{
                id:item_icon
                icon:modelData.icon
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var text  ="FluentIcons."+modelData.name;
                    FluApp.clipText(text)
                    showSuccess("您复制了 "+text)
                }
            }

            FluText {
                id:item_name
                font.pixelSize: 10;
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: item_icon.bottom
                text: modelData.name
            }

        }



    }
}
