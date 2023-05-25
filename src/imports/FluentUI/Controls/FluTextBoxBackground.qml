import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import FluentUI 1.0
import FluentGlobal 1.0 as G
Rectangle{
    property Item inputItem
    id:content
    radius: 4
    layer.enabled: true
    color: {
        if(inputItem.disabled){
            return G.FluTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(252/255,252/255,252/255,1)
        }
        if(inputItem.focus){
            return G.FluTheme.dark ? Qt.rgba(36/255,36/255,36/255,1) : Qt.rgba(1,1,1,1)
        }
        if(inputItem.hovered){
            return G.FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
        }
        return G.FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(1,1,1,1)
    }
    layer.effect:OpacityMask {
        maskSource: Rectangle {
            width: content.width
            height: content.height
            radius: 4
        }
    }
    border.width: 1
    border.color: {
        if(inputItem.disabled){
            return G.FluTheme.dark ? Qt.rgba(73/255,73/255,73/255,1) : Qt.rgba(237/255,237/255,237/255,1)
        }
        return G.FluTheme.dark ? Qt.rgba(76/255,76/255,76/255,1) : Qt.rgba(240/255,240/255,240/255,1)
    }
    Rectangle{
        width: parent.width
        height: inputItem.focus ? 3 : 1
        anchors.bottom: parent.bottom
        visible: !inputItem.disabled
        color: {
            if(G.FluTheme.dark){
                inputItem.focus ? G.FluTheme.primaryColor.lighter  : Qt.rgba(166/255,166/255,166/255,1)
            }else{
                return inputItem.focus ? G.FluTheme.primaryColor.dark  : Qt.rgba(183/255,183/255,183/255,1)
            }
        }
        Behavior on height{
            NumberAnimation{
                duration: 167
                easing.type: Easing.Bezier
                easing.bezierCurve: [ 1, 0, 0, 0 ]
            }
        }
    }
}
