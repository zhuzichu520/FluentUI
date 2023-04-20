import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluWindow {

    width: 640
    height: 480
    minimumWidth: 640
    minimumHeight: 480

    title:"视频播放器"

    onInitArgument:
        (argument)=>{
            player.source = argument.source
        }

    FluAppBar{
        id:appbar
        title:"视频播放器"
        width:parent.width
    }


    FluMediaPlayer{
        id:player
        anchors{
            left: parent.left
            right: parent.right
            top: appbar.bottom
            bottom: parent.bottom
        }
    }

}
