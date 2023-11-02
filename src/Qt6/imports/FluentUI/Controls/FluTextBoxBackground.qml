import QtQuick
import QtQuick.Controls
import FluentUI

FluClip{
    property Item inputItem
    property int borderWidth: 1
    id:control
    radius: [4,4,4,4]
    Rectangle{
        radius: 4
        anchors.fill: parent
        color: {
            if(inputItem.disabled){
                return FluTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(252/255,252/255,252/255,1)
            }
            if(inputItem.activeFocus){
                return FluTheme.dark ? Qt.rgba(36/255,36/255,36/255,1) : Qt.rgba(1,1,1,1)
            }
            if(inputItem.hovered){
                return FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
            }
            return FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(1,1,1,1)
        }
        border.width: control.borderWidth
        border.color: {
            if(inputItem.disabled){
                return FluTheme.dark ? Qt.rgba(73/255,73/255,73/255,1) : Qt.rgba(237/255,237/255,237/255,1)
            }
            return FluTheme.dark ? Qt.rgba(76/255,76/255,76/255,1) : Qt.rgba(240/255,240/255,240/255,1)
        }
    }
    Rectangle{
        width: parent.width
        height: inputItem.activeFocus ? 2 : 1
        anchors.bottom: parent.bottom
        visible: !inputItem.disabled
        color: {
            if(inputItem.activeFocus){
                return FluTheme.primaryColor
            }
            if(FluTheme.dark){
                return Qt.rgba(166/255,166/255,166/255,1)
            }else{
                return Qt.rgba(134/255,134/255,134/255,1)
            }
        }
        Behavior on height{
            enabled: FluTheme.enableAnimation
            NumberAnimation{
                duration: 83
                easing.type: Easing.OutCubic
            }
        }
    }
}
