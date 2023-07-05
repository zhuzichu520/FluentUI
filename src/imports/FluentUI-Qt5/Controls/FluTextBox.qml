import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

TextField{
    signal commit
    property bool disabled: false
    property int iconSource: 0
    property color normalColor: FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    property color disableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    property color placeholderNormalColor: FluTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    property color placeholderFocusColor: FluTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color placeholderDisableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    property int closeRightMargin: icon_end.visible ? 25 : 5
    id:control
    width: 300
    padding: 8
    leftPadding: padding+2
    enabled: !disabled
    color: {
        if(!enabled){
            return disableColor
        }
        return normalColor
    }
    font:FluTextStyle.Body
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    selectionColor: FluTheme.primaryColor.lightest
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
    Keys.onEnterPressed: (event)=> d.handleCommit(event)
    Keys.onReturnPressed:(event)=> d.handleCommit(event)
    QtObject{
        id:d
        function handleCommit(event){
            control.commit()
        }
    }
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.RightButton
        onClicked: control.echoMode !== TextInput.Password && menu.popup()
    }
    FluIconButton{
        iconSource:FluentIcons.ChromeClose
        iconSize: 10
        width: 20
        height: 20
        visible: {
            if(control.readOnly)
                return false
            return control.text !== ""
        }
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: closeRightMargin
        }
        contentDescription:"清空"
        onClicked:{
            control.text = ""
        }
    }
    FluTextBoxMenu{
        id:menu
        inputItem: control
    }
}

