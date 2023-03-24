import QtQuick 2.15
import QtMultimedia 5.9

Item {
    width: 320
    height: 240

    MediaPlayer {
        id: mediaplayer
        source: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
    }


    VideoOutput {
        anchors.fill: parent
        source: mediaplayer
    }

    MouseArea {
        anchors.fill: parent
        onPressed:  {
            console.debug("------>")
            mediaplayer.play()
        }
    }

}

