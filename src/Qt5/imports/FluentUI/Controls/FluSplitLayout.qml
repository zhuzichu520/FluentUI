import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

SplitView {
    property color handleColor : FluTheme.dark ? Qt.rgba(159/255,159/255,159/255,1) : Qt.rgba(138/255,138/255,138/255,1)
    id:control
    QtObject{
        id:d
        property bool isVertical: control.orientation === Qt.Vertical
    }
    handle: Rectangle {
        implicitWidth: 12
        implicitHeight: 12
        clip: true
        color: {
            if(SplitHandle.pressed){
                return FluTheme.itemPressColor
            }
            return SplitHandle.hovered ? FluTheme.itemHoverColor : FluTheme.itemNormalColor
        }
        Rectangle{
            width: d.isVertical ? 26 : 4
            height: d.isVertical ? 4 : 26
            anchors.centerIn: parent
            color: control.handleColor
            radius: 2
        }
    }
}
