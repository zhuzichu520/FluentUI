import QtQuick 2.15
import QtQuick.Window 2.15
import FluentUI 1.0


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
        color: FluTheme.dark ? Qt.rgba(80/255,80/255,80/255,1) : Qt.rgba(210/255,210/255,210/255,1)
        width: d.isVertical ? size : parent.width
        height: d.isVertical ? parent.height : size
        anchors.centerIn: parent
    }

}
