import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

Item {
    property alias title: text_title.text
    default property alias content: container.data
    property int leftPadding: 10
    property int topPadding: 0
    property int rightPadding: 10
    property int bottomPadding: 10
    property int pageMode: FluNavigationView.Standard
    property string url: ''
    id:control
    FluText{
        id:text_title
        font: FluTextStyle.TitleLarge
        anchors{
            top: parent.top
            topMargin: control.topPadding
            left: parent.left
            right: parent.right
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
        }
    }
    Item{
        clip: true
        id:container
        anchors{
            left: parent.left
            right: parent.right
            top: text_title.bottom
            bottom: parent.bottom
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
            bottomMargin: control.bottomPadding
        }
    }
}
