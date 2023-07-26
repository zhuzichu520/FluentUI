import QtQuick
import Qt.labs.platform
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import FluentUI
import "qrc:///example/qml/component"

FluContentPage{

    title:"Http"

    FluHttp{
        id:http
    }

    ListModel{
        id:data_model
        ListElement{
            name:"Get请求"
            onClickListener : function(){
                var callable = {}
                callable.onStart = function(){
                    showLoading()
                }
                callable.onFinish = function(){
                    hideLoading()
                }
                callable.onSuccess = function(result){
                    text_info.text = result
                    console.debug(result)
                }
                callable.onError = function(status,errorString){
                    console.debug(status+";"+errorString)
                }
                http.get("https://httpbingo.org/get",callable)
            }
        }
        ListElement{
            name:"Post表单请求"
            onClickListener : function(){
                var callable = {}
                callable.onStart = function(){
                    showLoading()
                }
                callable.onFinish = function(){
                    hideLoading()
                }
                callable.onSuccess = function(result){
                    text_info.text = result
                    console.debug(result)
                }
                callable.onError = function(status,errorString){
                    console.debug(status+";"+errorString)
                }
                var param = {}
                param.custname = "朱子楚"
                param.custtel = "1234567890"
                param.custemail = "zhuzichu520@gmail.com"
                http.post("https://httpbingo.org/post",callable,param)
            }
        }
        ListElement{
            name:"Post Json请求"
            onClickListener : function(){
                var callable = {}
                callable.onStart = function(){
                    showLoading()
                }
                callable.onFinish = function(){
                    hideLoading()
                }
                callable.onSuccess = function(result){
                    text_info.text = result
                    console.debug(result)
                }
                callable.onError = function(status,errorString){
                    console.debug(status+";"+errorString)
                }
                var param = {}
                param.custname = "朱子楚"
                param.custtel = "1234567890"
                param.custemail = "zhuzichu520@gmail.com"
                http.postJson("https://httpbingo.org/post",callable,param)
            }
        }
        ListElement{
            name:"Post String请求"
            onClickListener : function(){
                var callable = {}
                callable.onStart = function(){
                    showLoading()
                }
                callable.onFinish = function(){
                    hideLoading()
                }
                callable.onSuccess = function(result){
                    text_info.text = result
                    console.debug(result)
                }
                callable.onError = function(status,errorString){
                    console.debug(status+";"+errorString)
                }
                var param = "我命由我不由天"
                http.postString("https://httpbingo.org/post",callable,param)
            }
        }
    }


    ListView{
        id:list_view
        width: 160
        clip: true
        anchors{
            top: parent.top
            topMargin: 20
            bottom: parent.bottom
            left: parent.left
        }
        model:data_model
        delegate: FluButton{
            implicitWidth: ListView.view.width
            implicitHeight: 30
            text: model.name
            onClicked: {
                model.onClickListener()
            }
        }
    }

    FluArea{
        anchors{
            top: list_view.top
            bottom: list_view.bottom
            left: list_view.right
            right: parent.right
        }
        Flickable{
            clip: true
            id:scrollview
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
