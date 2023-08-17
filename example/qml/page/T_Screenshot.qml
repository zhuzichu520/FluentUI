import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///example/qml/component"

FluScrollablePage{

    title:"Screenshot"

    FluArea{
        Layout.fillWidth: true
        height: 100
        paddings: 10
        Layout.topMargin: 20

        FluFilledButton{
            anchors{
                top: parent.top
                topMargin: 14
            }
            text:"Open Screenshot"
            onClicked: {
                screenshot.open()
            }
        }
    }

    Image{
        id:image
        Layout.preferredHeight: 400
        Layout.preferredWidth: 400
        fillMode: Image.PreserveAspectFit
    }

    FluScreenshot{
        id:screenshot
        captrueMode: FluScreenshotType.File
        saveFolder: FluTools.getApplicationDirPath()+"/screenshot"
        onCaptrueCompleted:
            (captrue)=>{

                //C:/Users/zhuzi/Pictures/1692283885126.png
                image.source = captrue
            }
    }
}
