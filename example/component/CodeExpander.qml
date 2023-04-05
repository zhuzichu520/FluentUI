import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluExpander{

    property string code: ""

    headerText: "Source"
    contentHeight:content.height

    FluMultilineTextBox{
        id:content
        width:parent.width
        readOnly:true
        text:code
        background:Rectangle{
            color:FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,0.97) : Qt.rgba(237/255,237/255,237/255,0.97)
        }
    }

    FluIconButton{
        iconSource:FluentIcons.Copy
        anchors{
            right: parent.right
            top: parent.top
            rightMargin: 5
            topMargin: 5
        }
        onClicked:{
            FluApp.clipText(content.text)
            showSuccess("复制成功")
        }
    }

}
