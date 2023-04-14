import QtQuick 2.15
import QtQuick.Controls  2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "./component"

FluScrollablePage{

    title:"FlipView"
    leftPadding:10
    rightPadding:10
    bottomPadding:20
    spacing: 0

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
                    source: "qrc:/res/image/banner_1.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/res/image/banner_2.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/res/image/banner_3.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        code:'FluFlipView{
    Image{
        source: "qrc:/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/res/image/banner_1.jpg"
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
                    source: "qrc:/res/image/banner_1.jpg"
                    asynchronous: true
                    sourceSize: Qt.size(400,300)
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/res/image/banner_2.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
                Image{
                    source: "qrc:/res/image/banner_3.jpg"
                    asynchronous: true
                    fillMode:Image.PreserveAspectCrop
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        code:'FluFlipView{
    vertical:true
    Image{
        source: "qrc:/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
    Image{
        source: "qrc:/res/image/banner_1.jpg"
        asynchronous: true
        fillMode:Image.PreserveAspectCrop
    }
}
'
    }
}
