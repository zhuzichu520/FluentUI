import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluContentPage{

    title: "FluentUI Pro"

    Image{
        id: iamge_logo
        width: 80
        height: 80
        source: "qrc:/example/res/image/logo_pro.png"
    }

    Flickable{
        anchors{
            top: iamge_logo.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        ScrollBar.vertical: FluScrollBar {}
        ScrollBar.horizontal: FluScrollBar {}
        contentWidth: text.width
        contentHeight: text.height
        clip: true
        FluText{
            id: text
            textFormat: Text.MarkdownText
            onLinkActivated:
                (link)=> {
                    Qt.openUrlExternally(link)
                }
            onLinkHovered:
                (link)=> {
                    if(link === ""){
                        FluTools.restoreOverrideCursor()
                    }else{
                        FluTools.setOverrideCursor(Qt.PointingHandCursor)
                    }
                }
            text:'
基于[FluentUI](https://github.com/zhuzichu520/FluentUI)开源版本重新打造的项目,代码更加漂亮,API更加好用,界面更加细腻

## 与开源版本有啥不同?

1. 开源版本支持Qt6与Qt5.15.2,Pro版本仅支持Qt6
2. 开源版本所有组件都有Flu前缀,Pro版本去掉Flu前缀,只需添加一行```qputenv("QT_QUICK_CONTROLS_STYLE", "FluentUI");```代码,就能将原有Button换成FluentUI样式
3. 项目整体架构不同,开源版本代码都写在一个模块下,Pro版本分为FluentUI,FluentUI.Controls,FluentUI.impl三个模块
4. 开源版本不支持热加载，Pro版本支持热加载，运行之后修改代码可实时关注QML界面变化，支持一键关闭开启
5. 开源版不支持wasm编译，Pro版本支持wasm编译
6. 开源版本过于臃肿，Pro版本做了减法，去其糟粕，取其精华，重新打造
7. 开源版默认动态库依赖，Pro版本默认静态库依赖
8. 开源版MIT协议免费，Pro版本付费，如有需要请联系作者wx购买：FluentUI

## 下载Pro版本
[下载地址](https://github.com/zhuzichu520/FluentUI-Pro-Installer/releases)'
        }
    }

}
