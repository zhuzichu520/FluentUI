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

    FluScreenshot{
        id:screenshot
    }
}
