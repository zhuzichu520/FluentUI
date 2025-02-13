import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluContentPage{

    title: qsTr("SplitLayout")

    RowLayout{
        id:layout_dropdown
        anchors{
            top: parent.top
        }
        FluText{
            text: qsTr("orientation:")
        }
        FluDropDownButton{
            id:btn_orientation
            Layout.preferredWidth: 120
            text: qsTr("Horizontal")
            FluMenuItem{
                text: qsTr("Horizontal")
                onClicked: {
                    btn_orientation.text = text
                    split_layout.orientation = Qt.Horizontal
                }
            }
            FluMenuItem{
                text: qsTr("Vertical")
                onClicked: {
                    btn_orientation.text = text
                    split_layout.orientation = Qt.Vertical
                }
            }
        }
    }
    FluSplitLayout {
        id:split_layout
        anchors{
            top: layout_dropdown.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 8
        }
        orientation: Qt.Horizontal
        Item {
            clip: true
            implicitWidth: 200
            implicitHeight: 200
            SplitView.maximumWidth: 400
            SplitView.maximumHeight: 400
            FluText {
                text: qsTr("Page 1")
                anchors.centerIn: parent
            }
        }
        Item {
            clip: true
            id: centerItem
            SplitView.minimumWidth: 50
            SplitView.minimumHeight: 50
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            FluText {
                text: qsTr("Page 2")
                anchors.centerIn: parent
            }
        }
        Item {
            clip: true
            implicitWidth: 200
            implicitHeight: 200
            FluText {
                text: qsTr("Page 3")
                anchors.centerIn: parent
            }
        }
    }
}
