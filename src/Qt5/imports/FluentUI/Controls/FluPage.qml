import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FluentUI 1.0

Page {
    property int launchMode: FluPageType.SingleTop
    property bool animationEnabled: FluTheme.animationEnabled
    property string url : ""
    id: control
    StackView.onRemoved: destroy()
    padding: 5
    visible: false
    opacity: visible
    transform: Translate {
        y: control.visible ? 0 : 80
        Behavior on y{
            enabled: control.animationEnabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
    }
    Behavior on opacity {
        enabled: control.animationEnabled
        NumberAnimation{
            duration: 83
        }
    }
    background: Item{}
    header: Item{
        implicitHeight: 40
        FluText{
            id:text_title
            text: control.title
            font: FluTextStyle.Title
            anchors{
                left: parent.left
                leftMargin: 5
            }
        }
    }
    Component.onCompleted: {
        control.visible = true
    }
}
