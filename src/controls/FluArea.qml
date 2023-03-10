import QtQuick 2.15
import FluentUI 1.0

Rectangle {
    radius: 4
    color: FluTheme.isDark ? Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    border.color: FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
    border.width: 1
    implicitHeight: height
    implicitWidth: width

    default property alias content: container.data
    property int paddings : 0
    property int leftPadding : 0
    property int rightPadding : 0
    property int topPadding : 0
    property int bottomPadding : 0

    Item {
        id: container
        anchors.fill: parent
        anchors.leftMargin: Math.max(paddings,leftPadding)
        anchors.rightMargin: Math.max(paddings,rightPadding)
        anchors.topMargin: Math.max(paddings,topPadding)
        anchors.bottomMargin: Math.max(paddings,bottomPadding)
    }

}
