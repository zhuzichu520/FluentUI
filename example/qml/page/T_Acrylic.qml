import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Acrylic"

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 1200/5+20
        paddings: 10

        FluRectangle{
            width: 1920/5
            height: 1200/5
            radius:[15,15,15,15]
            Image {
                id:image
                asynchronous: true
                source: "qrc:/example/res/image/banner_3.jpg"
                anchors.fill: parent
                sourceSize: Qt.size(2*width,2*height)
            }
            FluAcrylic {
                sourceItem:image
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: 100
                height: 100
                FluText {
                    anchors.centerIn: parent
                    text: "Acrylic"
                    color: "#FFFFFF"
                    font.bold: true
                }
            }
            Layout.topMargin: 20
        }

    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'Image{
    id:image
    width: 800
    height: 600
    source: "qrc:/example/res/image/image_huoyin.webp"
    radius: 8
    }
    FluAcrylic{
        sourceItem:image
        width: 100
        height: 100
        anchors.centerIn: parent
}'
    }

}
