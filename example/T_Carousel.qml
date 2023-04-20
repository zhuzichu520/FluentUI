import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "./component"

FluScrollablePage{

    title:"Carousel"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

    FluArea{
        Layout.fillWidth: true
        height: 370
        paddings: 10
        Layout.topMargin: 20
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }
            FluText{
                text:"轮播图，支持无限轮播，无限滑动，用ListView实现的组件"
            }
            FluCarousel{
                id:carousel
                Layout.topMargin: 20
                Layout.leftMargin: 5
                Component.onCompleted: {
                    carousel.setData([{url:"qrc:/res/image/banner_1.jpg"},{url:"qrc:/res/image/banner_2.jpg"},{url:"qrc:/res/image/banner_3.jpg"}])
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluCarousel{
    width: 400
    height: 300
    Component.onCompleted: {
        setData([{url:"qrc:/res/image/banner_1.jpg"},{url:"qrc:/res/image/banner_2.jpg"},{url:"qrc:/res/image/banner_3.jpg"}])
    }
}'
    }
}
