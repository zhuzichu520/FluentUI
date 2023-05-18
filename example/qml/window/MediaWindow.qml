import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import "../component"

CustomWindow {

    title:"视频播放器"
    width: 640
    height: 480
    minimumWidth: 640
    minimumHeight: 480

    onInitArgument:
        (argument)=>{
            player.source = argument.source
        }

    FluMediaPlayer{
        id:player
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

}
