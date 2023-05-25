import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
TextArea{
    property bool disabled: false
    property color normalColor: G.FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    property color disableColor: G.FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    property color placeholderNormalColor: G.FluTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    property color placeholderFocusColor: G.FluTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color placeholderDisableColor: G.FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    id:control
    width: 300
    enabled: !disabled
    color: {
        if(disabled){
            return disableColor
        }
        return normalColor
    }
    font:FluTextStyle.Body
    wrapMode: Text.WrapAnywhere
    renderType: G.FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    selectionColor: G.FluTheme.primaryColor.lightest
    placeholderTextColor: {
        if(disabled){
            return placeholderDisableColor
        }
        if(focus){
            return placeholderFocusColor
        }
        return placeholderNormalColor
    }
    selectByMouse: true
    background: FluTextBoxBackground{ inputItem: control }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: control.echoMode !== TextInput.Password && menu.popup()
    }
    FluTextBoxMenu{
        id:menu
        inputItem: control
    }
}
