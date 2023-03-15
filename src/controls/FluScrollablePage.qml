import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {

    id:root

    property alias title: text_title.text
    default property alias content: container.data
    property int spacing : 5

    FluText{
        id:text_title
        fontStyle: FluText.TitleLarge
    }

    Flickable{
        clip: true
        width: parent.width
        contentWidth: parent.width
        contentHeight: container.height
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar { }
        anchors{
            top: text_title.bottom
            bottom: parent.bottom
        }
        ColumnLayout{
            id:container
            spacing: root.spacing
            width: parent.width
        }
    }
}
