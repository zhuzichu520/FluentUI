import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

FluWindow {

    width: 640
    height: 480
    minimumWidth: 640
    minimumHeight: 480

    title:"视频播放器"


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
        //                source:"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4"
        source:"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        //                source:"http://video.chinanews.com/flv/2019/04/23/400/111773_web.mp4"
    }


}
