import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import FluentUI 1.0
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"FlipView"

    FluArea{
        Layout.fillWidth: true
        height: 340
        paddings: 10
        Layout.topMargin: 20
        ColumnLayout{
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text:"水平方向的FlipView"
            }
            FluFlipView{
                Image{
                    source: "qrc:/example/res/image/banner_1.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/example/res/image/banner_2.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/example/res/image/banner_3.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluFlipView{
    Image{
        source: "qrc:/example/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/example/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/example/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
}
'
    }

    FluArea{
        Layout.fillWidth: true
        height: 340
        paddings: 10
        Layout.topMargin: 20
        ColumnLayout{
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text:"垂直方向的FlipView"
            }
            FluFlipView{
                vertical:true
                Image{
                    source: "qrc:/example/res/image/banner_1.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/example/res/image/banner_2.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/example/res/image/banner_3.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluFlipView{
    vertical:true
    Image{
        source: "qrc:/example/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/example/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/example/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
}
'
    }
}
