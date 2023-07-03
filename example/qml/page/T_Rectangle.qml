import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Rectangle"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 460
        paddings: 10

        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }

            RowLayout{
                Layout.topMargin: 20
                FluRectangle{
                    width: 50
                    height: 50
                    color:"#0078d4"
                    radius:[0,0,0,0]
                }
                FluRectangle{
                    width: 50
                    height: 50
                    color:"#744da9"
                    radius:[15,15,15,15]
                }
                FluRectangle{
                    width: 50
                    height: 50
                    color:"#ffeb3b"
                    radius:[15,0,0,0]
                }
                FluRectangle{
                    width: 50
                    height: 50
                    color:"#f7630c"
                    radius:[0,15,0,0]
                }
                FluRectangle{
                    width: 50
                    height: 50
                    color:"#e71123"
                    radius:[0,0,15,0]
                }
                FluRectangle{
                    width: 50
                    height: 50
                    color:"#b4009e"
                    radius:[0,0,0,15]
                }
            }
            FluText{
                text:"配合图片使用"
                font: FluTextStyle.Subtitle
                Layout.topMargin: 20
            }
            RowLayout{
                spacing: 14
                FluRectangle{
                    width: 50
                    height: 50
                    radius:[25,0,25,25]
                    Image {
                        asynchronous: true
                        anchors.fill: parent
                        source: "qrc:/example/res/svg/avatar_1.svg"
                        sourceSize: Qt.size(width,height)
                    }
                }
                FluRectangle{
                    width: 50
                    height: 50
                    radius:[10,10,10,10]
                    Image {
                        asynchronous: true
                        anchors.fill: parent
                        sourceSize: Qt.size(width,height)
                        source: "qrc:/example/res/svg/avatar_2.svg"
                    }
                }
                FluRectangle{
                    width: 50
                    height: 50
                    radius:[25,25,25,25]
                    Image {
                        asynchronous: true
                        anchors.fill: parent
                        sourceSize: Qt.size(width,height)
                        source: "qrc:/example/res/svg/avatar_3.svg"
                    }
                }
                FluRectangle{
                    width: 50
                    height: 50
                    radius:[0,25,25,25]
                    Image {
                        asynchronous: true
                        anchors.fill: parent
                        sourceSize: Qt.size(width,height)
                        source: "qrc:/example/res/svg/avatar_4.svg"
                    }
                }
            }
            FluRectangle{
                width: 1920/5
                height: 1200/5
                radius:[15,15,15,15]
                Image {
                    asynchronous: true
                    source: "qrc:/example/res/image/banner_1.jpg"
                    anchors.fill: parent
                    sourceSize: Qt.size(2*width,2*height)
                }
                Layout.topMargin: 20
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluRectangle{
    radius: [25,25,25,25]
    width: 50
    height: 50
    Image{
        asynchronous: true
        anchors.fill: parent
        source: "qrc:/example/res/svg/avatar_4.svg"
        sourceSize: Qt.size(width,height)
    }
}'
    }


}
