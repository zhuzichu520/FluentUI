import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Item {

    property url logo
    property string title: ""
    property FluObject items
    property FluObject footerItems
    property int displayMode: FluNavigationView.Auto
    property Component autoSuggestBox
    property Component actionItem
    id:control
    Item {
        id:nav_app_bar
        width: parent.width
        height: 40
        RowLayout{
            height:parent.height
            spacing: 0
            FluIconButton{
                iconSource: FluentIcons.ChromeBack
                Layout.leftMargin: 5
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
            }
            FluIconButton{
                id:btn_nav
                iconSource: FluentIcons.GlobalNavButton
                iconSize: 15
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignVCenter
            }
            Image{
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20
                source: control.logo
                Layout.leftMargin: 12
                sourceSize: Qt.size(40,40)
                Layout.alignment: Qt.AlignVCenter
            }
            FluText{
                Layout.alignment: Qt.AlignVCenter
                text:control.title
                Layout.leftMargin: 12
                font: FluTextStyle.Body
            }
        }
    }
}
