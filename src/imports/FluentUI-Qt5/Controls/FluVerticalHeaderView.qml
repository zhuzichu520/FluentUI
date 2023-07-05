import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import FluentUI 1.0

T.VerticalHeaderView {
    id: control
    implicitWidth: Math.max(1, contentWidth)
    implicitHeight: syncView ? syncView.height : 0
    delegate: Rectangle {
        readonly property real cellPadding: 8
        implicitWidth: Math.max(control.width, text.implicitWidth + (cellPadding * 2))
        implicitHeight: text.implicitHeight + (cellPadding * 2)
        color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
        border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
        FluText {
            id: text
            text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole]
                                        : model[control.textRole])
                                   : modelData
            width: parent.width
            font.bold: true
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
