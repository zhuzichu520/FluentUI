import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluIconButton {

    id:control

    background: Rectangle{
        border.color: FluTheme.dark ? "#505050" : "#DFDFDF"
        border.width: 1
        implicitHeight: 42
        implicitWidth: layout_row.width+28
        radius: control.radius
        color:control.color
        FluFocusRectangle{
            visible: control.activeFocus
        }
    }

    component ItemKey:Rectangle{
        id:item_key_control
        property string text : ""
        color:FluTheme.primaryColor
        width: Math.max(item_text.implicitWidth+12,28)
        height: Math.max(item_text.implicitHeight,28)
        radius: 4
        Text{
            id:item_text
            color: FluTheme.dark ? Qt.rgba(0,0,0,1)  : Qt.rgba(1,1,1,1)
            font.pixelSize: 13
            text: item_key_control.text
            anchors.centerIn: parent
        }
    }

    Row{
        id:layout_row
        spacing: 5
        anchors.centerIn: parent
        ItemKey{
            text:"Ctrl"
        }
        ItemKey{
            text:"A"
        }
        Item{
            width: 3
            height: 1
        }
        FluIcon{
            iconSource: FluentIcons.EditMirrored
            iconSize: 13
            anchors{
                verticalCenter: parent.verticalCenter
            }
        }

    }

    FluContentDialog{
        id:content_dialog

    }

    onClicked: {
        content_dialog.open()
    }

}
