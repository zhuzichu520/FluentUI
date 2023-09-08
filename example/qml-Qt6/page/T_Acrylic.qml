import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Acrylic"

    RowLayout{
        spacing: 10
        Layout.topMargin: 20
        FluText{
            text:"tintColor:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluColorPicker{
            id:color_picker
        }
    }
    RowLayout{
        spacing: 10
        FluText{
            text:"tintOpacity:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluSlider{
            id:slider_tint_opacity
            value: 65
        }
    }
    RowLayout{
        spacing: 10
        FluText{
            text:"blurRadius:"
            Layout.alignment: Qt.AlignVCenter
        }
        FluSlider{
            id:slider_blur_radius
            value: 32
        }
    }
    FluArea{
        Layout.fillWidth: true
        height: 1200/4+20
        paddings: 10
        Layout.topMargin: 10
        FluRectangle{
            width: 1920/4
            height: 1200/4
            radius:[8,8,8,8]
            Image {
                id:image
                asynchronous: true
                source: "qrc:/example/res/image/bg_scenic.png"
                anchors.fill: parent
                sourceSize: Qt.size(2*width,2*height)
            }
            FluAcrylic {
                id:acrylic
                target: image
                width: 200
                height: 200
                tintOpacity: slider_tint_opacity.value/100
                tintColor: color_picker.colorValue
                blurRadius: slider_blur_radius.value
                x:(image.width-width)/2
                y:(image.height-height)/2
                FluText {
                    anchors.centerIn: parent
                    text: "Acrylic"
                    color: "#FFFFFF"
                    font.bold: true
                }
                MouseArea {
                    property point clickPos: Qt.point(0,0)
                    id:drag_area
                    anchors.fill: parent
                    onPressed: (mouse)=>{
                                   clickPos = Qt.point(mouse.x, mouse.y)
                               }
                    onPositionChanged: (mouse)=>{
                                           var delta = Qt.point(mouse.x - clickPos.x,mouse.y - clickPos.y)
                                           acrylic.x = acrylic.x + delta.x
                                           acrylic.y = acrylic.y + delta.y
                                       }
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
        target:image
        width: 100
        height: 100
        anchors.centerIn: parent
    }
}'
    }

}
