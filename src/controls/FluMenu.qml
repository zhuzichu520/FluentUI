import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Menu {

    default property alias content: container.data

    id: popup
    width: 140
    height: container.height

    background: Item {
        Rectangle{
            anchors.fill: parent
            color:FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,0.97) : Qt.rgba(237/255,237/255,237/255,0.97)
            radius: 5
        }
        FluShadow{
            radius: 5
        }
        Column{
            spacing: 5
            topPadding: 5
            bottomPadding: 5
            width: popup.width
            id:container
            function closePopup(){
                popup.close()
            }
        }
    }
}
