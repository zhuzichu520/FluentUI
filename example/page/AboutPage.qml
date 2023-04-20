import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluWindow {

    id:window

    width: 600
    height: 600
    minimumWidth: 600
    minimumHeight: 600
    maximumWidth: 600
    maximumHeight: 600
    launchMode: FluWindow.SingleTask

    title:"关于"

    FluAppBar{
        id:appbar
        title:"关于"
        width:parent.width
    }

    ColumnLayout{
        anchors{
            top: appbar.bottom
            left: parent.left
            right: parent.right
        }

        RowLayout{
            Layout.topMargin: 20
            Layout.leftMargin: 15
            spacing: 14
            FluText{
                text:"FluentUI"
                fontStyle: FluText.Title
            }
            FluText{
                text:"v%1".arg(appInfo.version)
                fontStyle: FluText.Body
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout{
            spacing: 14
            Layout.topMargin: 20
            Layout.leftMargin: 15
            FluText{
                text:"作者："
            }
            FluText{
                text:"朱子楚"
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text:"GitHub："
            }
            FluTextButton{
                id:text_hublink
                topPadding:0
                bottomPadding:0
                text:"https://github.com/zhuzichu520/FluentUI"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text_hublink.text)
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text:"B站："
            }
            FluTextButton{
                topPadding:0
                bottomPadding:0
                text:"https://www.bilibili.com/video/BV1mg4y1M71w/"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text)
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                id:text_info
                text:"如果该项目对你有作用，就请点击上方链接给一个免费的star，或者一键三连，谢谢！"
                ColorAnimation {
                    id: animation
                    target: text_info
                    property: "color"
                    from: "red"
                    to: "blue"
                    duration: 1000
                    running: true
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text:"捐赠："
            }
        }

        Item{
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 252
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 60
                Image{
                    width: 164.55
                    height: 224.25
                    source: "qrc:/res/image/qrcode_wx.jpg"
                }
                Image{
                    width: 162
                    height: 252
                    source: "qrc:/res/image/qrcode_zfb.jpg"
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                id:text_desc
                text:"个人开发，维护不易，你们的捐赠就是我继续更新的动力！\n有什么问题提Issues，只要时间充足我就会解决的！！"
            }
        }


    }
}
