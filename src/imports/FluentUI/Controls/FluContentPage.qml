import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluPage {
    property alias title: text_title.text
    default property alias content: container.data
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
        visible: text !== ""
        height: visible ? contentHeight : 0
        font: FluTextStyle.Title
        anchors{
            top: parent.top
            topMargin: control.topPadding
            left: parent.left
            right: parent.right
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
        }
    }
    FluStatusView{
        id:status_view
        color: "#00000000"
        statusMode: FluStatusView.Success
        onErrorClicked: control.errorClicked()
        anchors{
            left: parent.left
            right: parent.right
            top: text_title.bottom
            bottom: parent.bottom
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
            bottomMargin: control.bottomPadding
        }
        Item{
            clip: true
            id:container
            anchors.fill: parent
        }
    }
}
