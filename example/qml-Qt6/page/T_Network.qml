import QtQuick
import Qt.labs.platform
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import FluentUI
import "qrc:///example/qml/component"

FluContentPage{

    title:"Network"

    FluNetworkCallable{
        id:callable
        onStart: {
            showLoading()
        }
        onFinish: {
            hideLoading()
        }
        onError:
            (status,errorString,result)=>{
                console.debug(status+";"+errorString+";"+result)
            }
        onSuccess:
            (result)=>{
                text_info.text = result
            }
    }

    Flickable{
        id:layout_flick
        width: 200
        clip: true
        anchors{
            top: parent.top
            topMargin: 20
            bottom: parent.bottom
            left: parent.left
        }
        ScrollBar.vertical: FluScrollBar {}
        contentHeight:layout_column.height
        Column{
            spacing: 2
            id:layout_column
            width: parent.width
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Get"
                onClicked: {
                    FluNetwork.get("https://httpbingo.org/get")
                    .setTimeOut(10000)//默认15000毫秒
                    .setRetry(2)//默认3次
                    .addQuery("name","孙悟空")
                    .addQuery("age",500)
                    .addQuery("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Head"
                onClicked: {
                    FluNetwork.head("https://httpbingo.org/head")
                    .addQuery("name","孙悟空")
                    .addQuery("age",500)
                    .addQuery("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post Body"
                onClicked: {
                    FluNetwork.postBody("https://httpbingo.org/post")
                    .setBody("花果山水帘洞美猴王齐天大圣孙悟空")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post JSON"
                onClicked: {
                    FluNetwork.postJson("https://httpbingo.org/post")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post JSON Array"
                onClicked: {
                    FluNetwork.postJsonArray("https://httpbingo.org/post")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }
            FluButton{
                implicitWidth: parent.width
                implicitHeight: 36
                text: "Post Form"
                onClicked: {
                    FluNetwork.postForm("https://httpbingo.org/post")
                    .add("name","孙悟空")
                    .add("age",500)
                    .add("address","花果山水帘洞")
                    .go(callable)
                }
            }

        }
    }

    FluArea{
        anchors{
            top: layout_flick.top
            bottom: layout_flick.bottom
            left: layout_flick.right
            right: parent.right
            leftMargin: 8
        }
        Flickable{
            clip: true
            id:scrollview
            boundsBehavior:Flickable.StopAtBounds
            width: parent.width
            height: parent.height
            contentWidth: width
            contentHeight: text_info.height
            ScrollBar.vertical: FluScrollBar {}
            FluText{
                id:text_info
                width: scrollview.width
                wrapMode: Text.WrapAnywhere
                padding: 14
            }
        }
    }
}
