import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluWindow {

    width: 500
    height: 600
    minimumWidth: 500
    minimumHeight: 600
    maximumWidth: 500
    maximumHeight: 600

    title:"关于"

    FluAppBar{
        id:appbar
        title:"关于"
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
                text:"v1.1.4"
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
            Layout.topMargin: 20
            Layout.leftMargin: 15
            FluText{
                text:"GitHub："
            }
            FluTextButton{
                id:text_hublink
                text:"https://github.com/zhuzichu520/FluentUI"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text_hublink.text)
                }
            }
        }
        RowLayout{
            spacing: 14
            Layout.topMargin: 20
            Layout.leftMargin: 15
            FluText{
                id:text_info
                text:"如果该项目对你有作用，就请点击上方链接给一个免费的star吧！"
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
    }
}
