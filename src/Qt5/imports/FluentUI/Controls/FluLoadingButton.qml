import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluButton {
    property bool loading: false
    id: control
    disabled: loading
    contentItem: Row{
        spacing: 6
        FluText {
            text: control.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: control.font
            textColor: control.textColor
            anchors.verticalCenter: parent.verticalCenter
        }
        Item{
            width: control.loading ? 16 : 0
            height: 16
            anchors.verticalCenter: parent.verticalCenter
            visible: Number(width)!==0
            clip: true
            Behavior on width {
                enabled: FluTheme.animationEnabled
                NumberAnimation{
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
            FluProgressRing{
                width: 16
                height: 16
                strokeWidth:3
                anchors.centerIn: parent
            }
        }
    }
}
