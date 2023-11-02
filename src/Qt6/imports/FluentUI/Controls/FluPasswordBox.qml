import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI

TextField{
    signal commit(string text)
    property bool disabled: false
    property int iconSource: 0
    property color normalColor: FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    property color disableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    property color placeholderNormalColor: FluTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    property color placeholderFocusColor: FluTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color placeholderDisableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    id:control
    enabled: !disabled
    color: {
        if(!enabled){
            return disableColor
        }
        return normalColor
    }
    font:FluTextStyle.Body
    padding: 7
    rightPadding: 40
    leftPadding: padding+4
    echoMode:btn_reveal.pressed ? TextField.Normal : TextField.Password
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    selectionColor: FluTools.colorAlpha(FluTheme.primaryColor,0.25)
    selectedTextColor: color
    placeholderTextColor: {
        if(!enabled){
            return placeholderDisableColor
        }
        if(focus){
            return placeholderFocusColor
        }
        return placeholderNormalColor
    }
    selectByMouse: true
    background: FluTextBoxBackground{
        inputItem: control
        implicitWidth: 240
    }
    Keys.onEnterPressed: (event)=> d.handleCommit(event)
    Keys.onReturnPressed:(event)=> d.handleCommit(event)
    QtObject{
        id:d
        function handleCommit(event){
            control.commit(control.text)
        }
    }
    FluIconButton{
        id:btn_reveal
        iconSource:FluentIcons.RevealPasswordMedium
        iconSize: 10
        width: 30
        height: 20
        verticalPadding: 0
        horizontalPadding: 0
        iconColor: FluTheme.dark ? Qt.rgba(222/255,222/255,222/255,1) : Qt.rgba(97/255,97/255,97/255,1)
        visible: control.text !== ""
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 5
        }
    }
    FluTextBoxMenu{
        id:menu
        inputItem: control
    }
}
