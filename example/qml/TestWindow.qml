import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Window {
    id:window
    title: "132"
    visible: true
    width: 600
    color: "#00000000"
    height: 480

    FluInfoBar{
        id:info_bar
        root: window
    }

    Rectangle{
        anchors.fill: parent
        color: "#FFFFFF"
    }

    FluButton{
        x: 23
        y: 31
        text:"123"
        onClicked: {
            info_bar.showSuccess("asdasd")
        }
    }

    FluFilledButton{
        x: 23
        y: 95
        text: "asdasd"
        onClicked: {
            info_bar.showInfo("123132")
        }
    }

    FluTextBox{
        text: "asdasd"
        anchors.verticalCenterOffset: -59
        anchors.horizontalCenterOffset: -127
        anchors.centerIn: parent
    }

    FluProgressBar{
        x: 23
        y: 238

    }

    FluProgressRing{
        x: 18
        y: 283

    }

}
