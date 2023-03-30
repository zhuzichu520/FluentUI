import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluScrollablePage{

    title:"MediaPlayer"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    onVisibleChanged: {
        if(visible){
            player.play()
        }else{
            player.pause()
        }
    }

    FluArea{
        width: parent.width
        height: 320
        Layout.topMargin: 20
        paddings: 10
        ColumnLayout{
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }
            FluMediaPlayer{
                id:player
//                source:"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4"
                source:"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
//                source:"http://video.chinanews.com/flv/2019/04/23/400/111773_web.mp4"
            }
        }
    }
}

