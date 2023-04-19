import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Menu {

    default property alias content: container.data
    property bool animEnabled: false
    id: popup
    width: 140
    height: container.height
    modal:true
    dim:false
    enter: Transition {
        reversible: true
        NumberAnimation {
            property: "opacity"
            from:0
            to:1
            duration: 83
        }
    }

    exit:Transition {
        NumberAnimation {
            property: "opacity"
            from:1
            to:0
            duration: 83
        }
    }

    background:Item{
        FluShadow{
            radius: 5
        }
    }
    contentItem: Item {
        clip: true
        Rectangle{
            anchors.fill: parent
            color:FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,0.97) : Qt.rgba(237/255,237/255,237/255,0.97)
            radius: 5
        }
        Column{
            id:container
            spacing: 5
            topPadding: 5
            bottomPadding: 5
            width: popup.width
            function closePopup(){
                popup.close()
            }
        }
    }

    function getContainerHeight(){
        return container.height
    }

}
