import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

FluContentPage {

    title: qsTr("Icons")

    FluTextBox{
        id: text_box
        placeholderText: qsTr("Please enter a keyword")
        anchors{
            top: parent.top
        }
        onTextChanged: {
            grid_view.model = FluApp.iconData(text_box.text, false)
        }
    }
    FluToggleSwitch{
        id: toggle_switch
        anchors{
            left: text_box.right
            verticalCenter: text_box.verticalCenter
            leftMargin: 10
        }
        text: qsTr("Disabled")
    }
    GridView{
        id: grid_view
        cellWidth: 110
        cellHeight: 110
        clip: true
        boundsBehavior: GridView.StopAtBounds
        model: FluApp.iconData()
        ScrollBar.vertical: FluScrollBar {}
        anchors{
            topMargin: 10
            top: text_box.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: Item {
            width: 100
            height: 100
            FluIconButton{
                id:item_icon
                iconSource: modelData.icon
                iconSize: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                bottomPadding: 30
                anchors.fill: parent
                disabled: toggle_switch.checked
                onClicked: {
                    var text  ="FluentIcons."+modelData.name;
                    FluTools.clipText(text)
                    showSuccess(qsTr("You Copied ")+text)
                }
                FluText{
                    width: parent.width
                    horizontalAlignment: Qt.AlignHCenter
                    wrapMode: Text.WrapAnywhere
                    text: modelData.name
                    anchors.top: parent.top
                    anchors.topMargin: 60
                    enabled: !toggle_switch.checked
                }
            }
        }
    }
}
