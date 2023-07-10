import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FluentUI 1.0

Item {
    enum LaunchMode{
        Standard = 0,
        SingleTask = 1,
        SingleTop = 2,
        SingleInstance = 3
    }
    property int launchMode: FluPage.SingleTop
    property bool animDisabled: false
    property string url : ""
    id: control
    opacity: visible
    visible: false
    StackView.onRemoved: destroy()
    Behavior on opacity{
        enabled: !animDisabled && FluTheme.enableAnimation
        NumberAnimation{
            duration: 167
        }
    }
    transform: Translate {
        y: control.visible ? 0 : 80
        Behavior on y{
            enabled: !animDisabled && FluTheme.enableAnimation
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic
            }
        }
    }
    Component.onCompleted: {
        visible = true
    }
}
