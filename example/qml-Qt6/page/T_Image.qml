import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "../component"

FluScrollablePage{

    title: qsTr("Image")

    FluArea{
        Layout.fillWidth: true
        height: 260
        paddings: 10
        Layout.topMargin: 20
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }
            FluImage{
                width: 384
                height: 240
                source: "https://gitee.com/zhu-zichu/zhu-zichu/raw/74f075efe2f8d3c3bb7ba3c2259e403450e4050b/image/banner_4.jpg"
                errorButtonText: qsTr("Reload")
                onStatusChanged:{
                    if(status === Image.Error){
                        showError(qsTr("The image failed to load, please reload"))
                    }
                }
                clickErrorListener: function(){
                    source = "https://gitee.com/zhu-zichu/zhu-zichu/raw/74f075efe2f8d3c3bb7ba3c2259e403450e4050b/image/banner_1.jpg"
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluImage{
    width: 400
    height: 300
    source: "https://gitee.com/zhu-zichu/zhu-zichu/raw/74f075efe2f8d3c3bb7ba3c2259e403450e4050b/image/banner_1.jpg"
}'
    }

}
