import QtQuick
import QtQuick.Controls
import QtMultimedia
import Qt5Compat.GraphicalEffects
import FluentUI

Item {
    id:control
    width: 480
    height: 270

    property url source


    Rectangle{
        anchors.fill: parent
        color: FluColors.Black
    }

    MediaPlayer {
        id: mediaplayer
        property bool autoSeek:true
        source: control.source
        videoOutput: video_output
        onErrorOccurred: {
        }
        onPositionChanged: {
            if(autoSeek){
                slider.seek(mediaplayer.position*slider.maxValue/mediaplayer.duration)
            }
        }
        onMediaStatusChanged: {
            if(mediaStatus===6){
                slider.maxValue = mediaplayer.duration
            }
        }
    }

    onSourceChanged: {
        slider.seek(0)
        mediaplayer.play()
    }

    VideoOutput {
        id:video_output
        anchors.fill: parent
    }

    Item{
        height: 100
        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }

        Rectangle{
            anchors.fill: parent
            color:FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,0.97) : Qt.rgba(237/255,237/255,237/255,0.97)
            radius: 5
            layer.enabled: true
            layer.effect:  GaussianBlur {
                radius: 5
                samples: 16
            }
        }

        FluSlider{
            id:slider
            size:parent.width-20
            y:20
            anchors.horizontalCenter: parent.horizontalCenter
            enableTip:false
            onPressed: {
                mediaplayer.autoSeek = false
            }
            onReleased: {
                mediaplayer.position = value*mediaplayer.duration/slider.maxValue
                mediaplayer.autoSeek = true
            }
        }

        FluText{
            id:start_time
            anchors{
                top: slider.bottom
                topMargin: 10
                left: slider.left
            }
            text: formatDuration(slider.value*mediaplayer.duration/slider.maxValue)
        }


        FluText{
            id:end_time
            anchors{
                top: slider.bottom
                right: slider.right
                topMargin: 10
            }
            text: formatDuration(mediaplayer.duration)
        }

        FluIconButton{
            iconSize: 15
            iconSource: mediaplayer.playbackState === MediaPlayer.PlayingState ?   FluentIcons.Pause  : FluentIcons.Play
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 10
            }
            onClicked: {
                if(mediaplayer.playbackState === MediaPlayer.PlayingState){
                    mediaplayer.pause()
                }else{
                    mediaplayer.play()
                }
            }
        }

    }

    function formatDuration(duration) {
        const seconds = Math.floor(duration / 1000);
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const remainingSeconds = seconds % 60;
        return `${pad(hours)}:${pad(minutes)}:${pad(remainingSeconds)}`;
    }

    function pad(value) {
        return value.toString().padStart(2, '0');
    }



}

