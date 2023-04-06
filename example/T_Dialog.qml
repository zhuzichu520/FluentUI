import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "./component"

FluScrollablePage{

    title:"Dialog"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

    FluArea{
        Layout.fillWidth: true
        height: 68
        paddings: 10
        Layout.topMargin: 20
            FluButton{
                anchors.verticalCenter: parent.verticalCenter
                Layout.topMargin: 20
                text:"Show Dialog"
                onClicked: {
                    dialog.open()
                }
            }
    }
    CodeExpander{
        Layout.fillWidth: true
        code:'FluContentDialog{
    id:dialog
    title:"友情提示"
    message:"确定要退出程序么？"
    negativeText:"取消"
    onNegativeClicked:{
        showSuccess("点击取消按钮")
    }
    positiveText:"确定"
    onPositiveClicked:{
        showSuccess("点击确定按钮")
    }
}
dialog.open()
'
    }

    FluContentDialog{
        id:dialog
        title:"友情提示"
        message:"确定要退出程序么？"
        negativeText:"取消"
        onNegativeClicked:{
            showSuccess("点击取消按钮")
        }
        positiveText:"确定"
        onPositiveClicked:{
            showSuccess("点击确定按钮")
        }
    }


}
