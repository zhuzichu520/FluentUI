import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("FlipView")

    FluArea{
        Layout.fillWidth: true
        Layout.preferredHeight: 340
        padding: 10
        ColumnLayout{
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text: qsTr("Horizontal FlipView")
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
        Layout.topMargin: -6
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
        padding: 10
        Layout.topMargin: 20
        ColumnLayout{
            anchors.verticalCenter: parent.verticalCenter
            FluText{
                text: qsTr("Vertical FlipView")
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
        Layout.topMargin: -6
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
