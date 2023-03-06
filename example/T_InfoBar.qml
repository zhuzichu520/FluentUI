import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

Item {
    FluText{
        id:title
        text:"InfoBar"
        fontStyle: FluText.TitleLarge
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
                text:"Info"
                Layout.topMargin: 20
                onClicked: {
                    showInfo("这是一个Info样式的InfoBar")
                }
            }
            FluButton{
                text:"Warning"
                Layout.topMargin: 20
                onClicked: {
                    showWarning("这是一个Warning样式的InfoBar")
                }
            }
            FluButton{
                text:"Error"
                Layout.topMargin: 20
                onClicked: {
                    showError("这是一个Error样式的InfoBar")
                }
            }
            FluButton{
                text:"Success"
                Layout.topMargin: 20
                onClicked: {
                    showSuccess("这是一个Success样式的InfoBar这是一个Success样式的InfoBar")
                }
            }
        }
    }
}
