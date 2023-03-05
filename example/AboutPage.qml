import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluWindow {

    width: 500
    height: 600
    minimumWidth: 300
    minimumHeight: 400
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
                text:"v1.0.0.0"
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

    }



}
