import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import Qt.labs.platform
import "../component"

FluWindow {

    id:window
    title: qsTr("Friendly Reminder")
    width: 300
    height: 400
    fixSize: true
    showMinimize: false
    showStayTop: false
    stayTop:true

    property string crashFilePath

    onInitArgument:
        (argument)=>{
            crashFilePath = argument.crashFilePath
        }

    Image{
        width: 540/2
        height: 285/2
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 40
        }
        source: "qrc:/example/res/image/ic_crash.png"
    }

    FluText{
        id:text_info
        anchors{
            top: parent.top
            topMargin: 240
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
        }
        wrapMode: Text.WrapAnywhere
        text: qsTr("We apologize for the inconvenience caused by an unexpected error")
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    RowLayout{
        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }
        FluButton{
            text: qsTr("Report Logs")
            onClicked: {
                FluTools.showFileInFolder(crashFilePath)
            }
        }
        Item{
            width: 30
            height: 1
        }
        FluFilledButton{
            text: qsTr("Restart Program")
            onClicked: {
                FluApp.exit(931)
            }
        }
    }

}
