import QtQuick
import QtQuick.Controls
import FluentUI

FluMenu{
    property string cutText : qsTr("Cut")
    property string copyText : qsTr("Copy")
    property string pasteText : qsTr("Paste")
    property string selectAllText : qsTr("Select All")
    property var inputItem
    id:menu
    animationEnabled: false
    width: 120
    focus: false
    onVisibleChanged: {
        if(inputItem){
            inputItem.forceActiveFocus()
        }
    }
    Connections{
        target: {
            if(inputItem){
                return inputItem
            }
            return null
        }
        function onTextChanged() {
            menu.close()
        }
        function onActiveFocusChanged() {
            if(!inputItem.activeFocus){
                menu.close()
            }
        }
    }
    FluIconButton{
        display: Button.TextOnly
        text:cutText
        focus: false
        padding: 0
        height: visible ? 36 : 0
        visible: {
            if(inputItem){
                return inputItem.selectedText !== "" && !inputItem.readOnly
            }
            return false
        }
        onClicked: {
            inputItem.cut()
            menu.close()
        }
    }
    FluIconButton{
        display: Button.TextOnly
        text:copyText
        focus: false
        padding: 0
        height: visible ? 36 : 0
        visible: {
            if(inputItem){
                return inputItem.selectedText !== ""
            }
            return false
        }
        onClicked: {
            inputItem.copy()
            menu.close()
        }
    }
    FluIconButton{
        display: Button.TextOnly
        text:pasteText
        focus: false
        padding: 0
        visible: {
            if(inputItem){
                return !inputItem.readOnly
            }
            return false
        }
        height: visible ? 36 : 0
        onClicked: {
            inputItem.paste()
            menu.close()
        }
    }
    FluIconButton{
        display: Button.TextOnly
        text:selectAllText
        focus: false
        padding: 0
        height: visible ? 36 : 0
        visible: {
            if(inputItem){
                return inputItem.text !== ""
            }
            return false
        }
        onClicked: {
            inputItem.selectAll()
            menu.close()
        }
    }
}
