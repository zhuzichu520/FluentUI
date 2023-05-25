import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FluentUI 1.0
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
