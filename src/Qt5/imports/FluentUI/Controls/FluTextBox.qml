import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0

TextField{
    signal commit(string text)
    property bool disabled: false
    property int iconSource: 0
    property color normalColor: FluTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
    property color disableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    property color placeholderNormalColor: FluTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
    property color placeholderFocusColor: FluTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color placeholderDisableColor: FluTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
    property bool cleanEnabled: true
    id:control
    padding: 7
    leftPadding: padding+4
    enabled: !disabled
    color: {
        if(!enabled){
            return disableColor
        }
        return normalColor
    }
    font:FluTextStyle.Body
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    selectionColor: FluTools.withOpacity(FluTheme.primaryColor,0.5)
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
    rightPadding: {
        var w = 30
        if(control.cleanEnabled === false){
            w = 0
        }
        if(control.readOnly)
            w = 0
        return icon_end.visible ? w+36 : w+10
    }
    width: 240
    background: FluTextBoxBackground{
        inputItem: control
    }
    Keys.onEnterPressed: (event)=> d.handleCommit(event)
    Keys.onReturnPressed:(event)=> d.handleCommit(event)
    QtObject{
        id:d
        function handleCommit(event){
            control.commit(control.text)
        }
    }
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.RightButton
        onClicked: {
            if(control.echoMode === TextInput.Password){
                return
            }
            if(control.readOnly && control.text === ""){
                return
            }
            menu.popup()
        }
    }
    RowLayout{
        height: parent.height
        anchors{
            right: parent.right
            rightMargin: 5
        }
        spacing: 4
        FluIconButton{
            iconSource: FluentIcons.Cancel
            iconSize: 12
            Layout.preferredWidth: 30
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter
            iconColor: FluTheme.dark ? Qt.rgba(222/255,222/255,222/255,1) : Qt.rgba(97/255,97/255,97/255,1)
            verticalPadding: 0
            horizontalPadding: 0
            visible: {
                if(control.cleanEnabled === false){
                    return false
                }
                if(control.readOnly)
                    return false
                return control.text !== ""
            }
            contentDescription:"Clean"
            onClicked:{
                control.clear()
            }
        }
        FluIcon{
            id:icon_end
            iconSource: control.iconSource
            iconSize: 12
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 7
            iconColor: FluTheme.dark ? Qt.rgba(222/255,222/255,222/255,1) : Qt.rgba(97/255,97/255,97/255,1)
            visible: control.iconSource != 0
        }
    }
    FluTextBoxMenu{
        id:menu
        inputItem: control
    }
}
