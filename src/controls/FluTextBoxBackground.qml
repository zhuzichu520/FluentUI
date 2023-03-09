import QtQuick 2.15
import QtGraphicalEffects 1.15

Rectangle{
    id:content

    property Item inputItem

    radius: 4
    layer.enabled: true
    color: {
        if(input.focus){
            return FluTheme.isDark ? Qt.rgba(36/255,36/255,36/255,1) : Qt.rgba(1,1,1,1)
        }
        if(input.hovered){
            return FluTheme.isDark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
        }
        return FluTheme.isDark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(1,1,1,1)
    }
    layer.effect:OpacityMask {
        maskSource: Rectangle {
            width: content.width
            height: content.height
            radius: 4
        }
    }
    border.width: 1
    border.color: FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(238/255,238/255,238/255,1)
    Rectangle{
        width: parent.width
        height: input.focus ? 3 : 1
        anchors.bottom: parent.bottom
        color: {
            if(FluTheme.isDark){
                input.focus ? FluTheme.primaryColor.lighter  : Qt.rgba(166/255,166/255,166/255,1)
            }else{
                return input.focus ? FluTheme.primaryColor.dark  : Qt.rgba(183/255,183/255,183/255,1)
            }
        }
        Behavior on height{
            NumberAnimation{
                duration: 200
            }
        }
    }
}
