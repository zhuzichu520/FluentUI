import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluMenu{
    property string cutText : "剪切"
    property string copyText : "复制"
    property string pasteText : "粘贴"
    property string selectAllText : "全选"
    property var inputItem
    id:menu
    enableAnimation: false
    width: 120
    focus: false
    onVisibleChanged: {
        inputItem.forceActiveFocus()
    }
    Connections{
        target: inputItem
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
        visible: inputItem.selectedText !== "" && !inputItem.readOnly
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
        visible: inputItem.selectedText !== ""
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
        visible: inputItem.text !== ""
        onClicked: {
            inputItem.selectAll()
            menu.close()
        }
    }
}
