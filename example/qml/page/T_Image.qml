import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Image")

    FluFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 260
        padding: 10
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
        Layout.topMargin: -6
        code:'FluImage{
    width: 400
    height: 300
    source: "https://gitee.com/zhu-zichu/zhu-zichu/raw/74f075efe2f8d3c3bb7ba3c2259e403450e4050b/image/banner_1.jpg"
}'
    }

}
