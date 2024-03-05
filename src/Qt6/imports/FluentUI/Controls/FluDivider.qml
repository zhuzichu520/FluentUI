import QtQuick
import QtQuick.Window
import FluentUI

Item {
    id:control
    property int orientation: Qt.Horizontal
    property int spacing:0
    property int size: 1

    QtObject{
        id:d
        property bool isVertical : orientation === Qt.Vertical
    }

    width: d.isVertical ? spacing*2+size : parent.width
    height: d.isVertical ? parent.height : spacing*2+size

    FluRectangle{
        color: FluTheme.dividerColor
        width: d.isVertical ? size : parent.width
        height: d.isVertical ? parent.height : size
        anchors.centerIn: parent
    }

}
