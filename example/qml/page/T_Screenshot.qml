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
            anchors.verticalCenter: parent.verticalCenter
            text:"Open Screenshot"
            onClicked: {
                screenshot.open()
            }
        }
    }

    Rectangle{
        Layout.preferredHeight: 400
        Layout.preferredWidth: 400
        Layout.topMargin: 10
        Layout.leftMargin: 4
        color: FluTheme.dark ? FluColors.Black : FluColors.White
        FluShadow{
            radius: 0
            color: FluTheme.primaryColor.dark
        }
        Image{
            id:image
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }
    }

    FluScreenshot{
        id:screenshot
        captrueMode: FluScreenshotType.File
        saveFolder: FluTools.getApplicationDirPath()+"/screenshot"
        onCaptrueCompleted:
            (captrue)=>{
                image.source = captrue
            }
    }
}
