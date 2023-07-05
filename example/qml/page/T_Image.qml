import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Image"

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
                onStatusChanged:{
                    if(status === Image.Error){
                        showError("图片加载失败，请重新加载")
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
