import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    id: popup
    default property alias content: container.children

    background: FluRectangle {
        implicitWidth: 140
        implicitHeight: container.height
        color:FluApp.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(237/255,237/255,237/255,1)
        radius: [5,5,5,5]
        layer.effect: FluDropShadow{}
        layer.enabled: true
        Column{
            spacing: 5
            topPadding: 5
            bottomPadding: 5
            id:container
            function closePopup(){
                popup.close()
            }
        }
    }
}
