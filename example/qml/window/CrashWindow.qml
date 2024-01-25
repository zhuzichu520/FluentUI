import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import Qt.labs.platform 1.0
import "../component"

FluWindow {

    id:window
    title:"友情提示"
    width: 300
    height: 400
    fixSize: true
    showMinimize: false
    showStayTop: false

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
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 240
        }
        text:"发生意外错误\n给您带来的不便，我们深表歉意"
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
            text:"日志上报"
            onClicked: {
                FluTools.showFileInFolder(crashFilePath)
            }
        }
        Item{
            width: 30
            height: 1
        }
        FluFilledButton{
            text:"重启程序"
            onClicked: {
                FluApp.exit(931)
            }
        }
    }

}
