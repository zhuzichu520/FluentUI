import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage {

    title: qsTr("Awesome")

    FluTextBox{
        id:text_box
        placeholderText: qsTr("Please enter a keyword")
        anchors{
            top:parent.top
        }
    }

    FluFilledButton{
        text: qsTr("Search")
        anchors{
            left: text_box.right
            verticalCenter: text_box.verticalCenter
            leftMargin: 14
        }
        onClicked: {
            grid_view.model = FluTheme.awesomeList(text_box.text)
        }
    }
    GridView{
        id:grid_view
        cellWidth: 80
        cellHeight: 80
        clip: true
        boundsBehavior: GridView.StopAtBounds
        model:FluTheme.awesomeList()
        ScrollBar.vertical: FluScrollBar {}
        anchors{
            topMargin: 10
            top:text_box.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: Item {
            width: 68
            height: 80
            FluIconButton{
                id:item_icon
                iconSource:modelData.icon
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var text  ="FluentIcons."+modelData.name;
                    FluTools.clipText(text)
                    showSuccess(qsTr("You Copied ")+text)
                }
            }
            FluText {
                id:item_name
                font.pixelSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: item_icon.bottom
                width:parent.width
                wrapMode: Text.WrapAnywhere
                text: modelData.name
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
