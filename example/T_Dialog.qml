import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {

    FluText{
        id:title
       text:"Dialog"
        fontStyle: FluText.TitleLarge
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



    ScrollView{
        clip: true
        width: parent.width
        contentWidth: parent.width
        anchors{
            top: title.bottom
            bottom: parent.bottom
        }
        ColumnLayout{
            spacing: 5
            FluButton{
                Layout.topMargin: 20
                text:"Show Dialog"
                onClicked: {
                    dialog.open()
                }
            }
        }
    }
}
