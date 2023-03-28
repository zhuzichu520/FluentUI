import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

TextArea{

    property int fontStyle: FluText.Body
    property int pixelSize : FluTheme.textSize
    property bool disabled: false

    id:input
    width: 300
    color: {
        if(disabled){
            return FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        }
        return FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    }
    enabled: !disabled
    wrapMode: Text.WrapAnywhere
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    selectByMouse: true
    selectionColor: {
        if(FluTheme.dark){
            return FluTheme.primaryColor.lighter
        }else{
            return FluTheme.primaryColor.dark
        }
    }
    background: FluTextBoxBackground{
        inputItem: input
    }
    placeholderTextColor: {
        if(disabled){
            return FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        }
        if(focus){
            return FluTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
        }
        return FluTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    }
    font.bold: {
        switch (fontStyle) {
        case FluText.Display:
            return true
        case FluText.TitleLarge:
            return true
        case FluText.Title:
            return true
        case FluText.Subtitle:
            return true
        case FluText.BodyLarge:
            return false
        case FluText.BodyStrong:
            return true
        case FluText.Body:
            return false
        case FluText.Caption:
            return false
        default:
            return false
        }
    }

    font.pixelSize: {
        switch (fontStyle) {
        case FluText.Display:
            return input.pixelSize * 4
        case FluText.TitleLarge:
            return input.pixelSize * 2
        case FluText.Title:
            return input.pixelSize * 1.5
        case FluText.Subtitle:
            return input.pixelSize * 0.9
        case FluText.BodyLarge:
            return input.pixelSize * 1.1
        case FluText.BodyStrong:
            return input.pixelSize * 1.0
        case FluText.Body:
            return input.pixelSize * 1.0
        case FluText.Caption:
            return input.pixelSize * 0.8
        default:
            return input.pixelSize * 1.0
        }
    }


}
