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
        focus:false
        KeyNavigation.priority: KeyNavigation.BeforeItem
        background:Rectangle{
            radius: 4
            color:FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(247/255,247/255,247/255,1)
            border.color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
            border.width: 1
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
