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
    onVisibleChanged: {
        inputItem.forceActiveFocus()
    }
    Connections{
        target: inputItem
        function onTextChanged() {
            menu.close()
        }
    }
    FluMenuItem{
        text: cutText
        visible: inputItem.selectedText !== "" && !inputItem.readOnly
        onClicked: {
            inputItem.cut()
        }
    }
    FluMenuItem{
        text: copyText
        visible: inputItem.selectedText !== ""
        onClicked: {
            inputItem.copy()
        }
    }
    FluMenuItem{
        text: pasteText
        visible: inputItem.canPaste
        onClicked: {
            inputItem.paste()
        }
    }
    FluMenuItem{
        text: selectAllText
        visible: inputItem.text !== ""
        onClicked: {
            inputItem.selectAll()
        }
    }
}
