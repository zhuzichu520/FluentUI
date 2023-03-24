import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

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
