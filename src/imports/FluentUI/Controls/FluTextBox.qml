import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import FluentGlobal 1.0 as G
TextField{
    property bool disabled: false
    property int iconSource: 0
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
    rightPadding: icon_end.visible ? 50 : 30
    background: FluTextBoxBackground{
        inputItem: control
        FluIcon{
            id:icon_end
            iconSource: control.iconSource
            iconSize: 15
            opacity: 0.5
            visible: control.iconSource != 0
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 5
            }
        }
    }
    FluIconButton{
        iconSource:FluentIcons.ChromeClose
        iconSize: 10
        width: 20
        height: 20
        opacity: 0.5
        visible: control.text !== ""
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: icon_end.visible ? 25 : 5
        }
        onClicked:{
            control.text = ""
        }
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: control.echoMode !== TextInput.Password && menu.popup()
    }
    FluTextBoxMenu{
        id:menu
        inputItem: control
    }

}

