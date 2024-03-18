import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluPage {
    property alias title: text_title.text
    default property alias content: container.data
    property int spacing : 0
    property int leftPadding: 10
    property int topPadding: 0
    property int rightPadding: 10
    property int bottomPadding: 10
    property alias color: status_view.color
    property alias statusMode: status_view.statusMode
    property alias loadingText: status_view.loadingText
    property alias emptyText:status_view.emptyText
    property alias errorText:status_view.errorText
    property alias errorButtonText:status_view.errorButtonText
    property alias loadingItem :status_view.loadingItem
    property alias emptyItem : status_view.emptyItem
    property alias errorItem :status_view.errorItem
    signal errorClicked
    id:control
    FluText{
        id:text_title
        font: FluTextStyle.Title
        visible: text !== ""
        height: visible ? contentHeight : 0
        padding: 0
        anchors{
            top: parent.top
            topMargin: control.topPadding
            left: parent.left
            right: parent.right
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
        }
    }
    FluStatusLayout{
        id:status_view
        color: "#00000000"
        statusMode: FluStatusLayoutType.Success
        onErrorClicked: control.errorClicked()
        anchors{
            left: parent.left
            right: parent.right
            top: text_title.bottom
            bottom: parent.bottom
            bottomMargin: control.bottomPadding
        }
        Flickable{
            id:flickview
            clip: true
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: container.height
            ScrollBar.vertical: FluScrollBar {
                anchors.right: flickview.right
                anchors.rightMargin: 2
            }
            boundsBehavior: Flickable.StopAtBounds
            ColumnLayout{
                id:container
                spacing: control.spacing
                clip: true
                anchors{
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    leftMargin: control.leftPadding
                    rightMargin: control.rightPadding
                }
                width: parent.width
            }
        }
    }
}
