import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluWindow {

    id:window
    width: 800
    height: 400
    maximumSize: Qt.size(800,400)
    minimumSize: Qt.size(800,400)
    title:"安装向导"

    FluAppBar{
        id:appbar
        title: "安装向导"
    }

    ColumnLayout{

        width: parent.width

        anchors{
            top: appbar.bottom
            bottom: parent.bottom
            topMargin: 20
        }

        RowLayout{

            width: parent.width

            FluText{
                text:"安装路径:"
                Layout.leftMargin: 30
            }

            Rectangle{
                color: FluApp.isDark ? "#323232" : "#FFFFFF"
                radius: 4
                Layout.fillWidth: true
                height: 40
                border.width: 1
                border.color: FluApp.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(238/255,238/255,238/255,1)

                FluText{
                    text:"C:\\Program Files\\RustDesk"
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left:parent.left
                        leftMargin: 14
                    }
                }
            }

            FluButton{
                text:"更改路径"
                Layout.rightMargin: 30
            }
        }

        Item{
            width: 1
            Layout.fillHeight: true
        }


        Rectangle{

            Layout.fillWidth: true
            border.width: 1
            border.color: FluApp.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(238/255,238/255,238/255,1)

            height: 60
            color: FluApp.isDark ? "#323232" : "#FFFFFF"
            RowLayout{
                anchors{
                    right: parent.right
                    rightMargin: 30
                    verticalCenter: parent.verticalCenter
                }
                spacing: 14
                FluButton{
                    text:"取消"
                    onClicked: {
                        window.close()
                    }
                }
                FluFilledButton{
                    text:"同意并安装"
                }
                FluButton{
                    text:"不安装直接运行"
                    onClicked: {
                        FluApp.navigate("/")
                        window.close()
                    }
                }
            }
        }
    }
}
