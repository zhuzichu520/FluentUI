import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

T.HorizontalHeaderView {
    id: control
    implicitWidth: syncView ? syncView.width : 0
    implicitHeight: Math.max(1, contentHeight)
    delegate: Rectangle {
        readonly property real cellPadding: 8
        implicitWidth: text.implicitWidth + (cellPadding * 2)
        implicitHeight: Math.max(control.height, text.implicitHeight + (cellPadding * 2))
        color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
        border.color: FluTheme.dark ? "#252525" : "#e4e4e4"
        FluText {
            id: text
            text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole]
                                        : model[control.textRole])
                                   : modelData
            width: parent.width
            height: parent.height
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
