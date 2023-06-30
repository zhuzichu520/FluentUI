import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI

FluTextBox {
    id:control
    width: 200
    closeRightMargin:55
    rightPadding: 80
    text:"0"
    validator: IntValidator {}
    inputMethodHints: Qt.ImhDigitsOnly
    FluIconButton{
        width: 20
        height: 20
        iconSize: 16
        iconSource: FluentIcons.ChevronUp
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 30
        }
        onClicked: {
            control.text = Number(control.text) + 1
        }
    }
    FluIconButton{
        iconSource: FluentIcons.ChevronDown
        width: 20
        height: 20
        iconSize: 16
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 5
        }
        onClicked: {
            control.text = Number(control.text) - 1
        }
    }
}
