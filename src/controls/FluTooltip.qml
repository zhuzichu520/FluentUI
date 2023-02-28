import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

ToolTip {
    id:tool_tip

    contentItem: FluText {
        text: tool_tip.text
        font: tool_tip.font
        fontStyle: FluText.BodyLarge
        padding: 4
        wrapMode: Text.WrapAnywhere
    }

    background: Rectangle{
        anchors.fill: parent
        color: FluApp.isDark ? Qt.rgba(50/255,49/255,48/255,1) : Qt.rgba(1,1,1,1)
        radius: 5
        layer.enabled: true
        layer.effect: DropShadow {
             radius: 5
             samples: 4
             color: "#80000000"
         }
    }
}
