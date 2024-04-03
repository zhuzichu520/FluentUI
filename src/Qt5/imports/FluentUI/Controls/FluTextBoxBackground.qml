import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluControlBackground{
    property Item inputItem
    id:control
    color: {
        if(inputItem && inputItem.disabled){
            return FluTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(252/255,252/255,252/255,1)
        }
        if(inputItem && inputItem.activeFocus){
            return FluTheme.dark ? Qt.rgba(36/255,36/255,36/255,1) : Qt.rgba(1,1,1,1)
        }
        if(inputItem && inputItem.hovered){
            return FluTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
        }
        return FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(1,1,1,1)
    }
    border.width: 1
    gradient: Gradient {
        GradientStop { position: 0.0; color: d.startColor }
        GradientStop { position: 1 - 3/control.height; color: d.startColor }
        GradientStop { position: 1 - 2/control.height; color: d.startColor }
        GradientStop { position: 1.0; color: d.endColor }
    }
    bottomMargin: inputItem && inputItem.activeFocus ? 2 : 1
    QtObject{
        id:d
        property color startColor: FluTheme.dark ? Qt.rgba(66/255,66/255,66/255,1) : Qt.rgba(232/255,232/255,232/255,1)
        property color endColor: {
            if(!control.enabled){
                return d.startColor
            }
            return inputItem && inputItem.activeFocus ? FluTheme.primaryColor : FluTheme.dark ? Qt.rgba(123/255,123/255,123/255,1) : Qt.rgba(132/255,132/255,132/255,1)
        }
    }
}
