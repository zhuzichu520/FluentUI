import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {

    id:root

    property alias title: text_title.text
    default property alias content: container.data

    FluText{
        id:text_title
        fontStyle: FluText.TitleLarge
    }

    Item{
        clip: true
        id:container
        anchors{
            top: text_title.bottom
            bottom: parent.bottom
        }
        width: parent.width
    }

}
