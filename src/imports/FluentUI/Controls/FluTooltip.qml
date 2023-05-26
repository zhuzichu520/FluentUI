import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

ToolTip {
    id:tool_tip
    contentItem: FluText {
        text: tool_tip.text
        wrapMode: Text.WrapAnywhere
    }
    background: Rectangle{
        anchors.fill: parent
        color: FluTheme.dark ? Qt.rgba(50/255,49/255,48/255,1) : Qt.rgba(1,1,1,1)
        radius: 5
        FluShadow{}
    }
}
