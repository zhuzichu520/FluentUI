import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

FluScrollablePage{
    title:"Dialog"

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

    FluButton{
        Layout.topMargin: 20
        text:"Show Dialog"
        onClicked: {
            dialog.open()
        }
    }
}
