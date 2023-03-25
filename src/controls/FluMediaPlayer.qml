import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import FluentUI 1.0

Rectangle {

    property url source
    id:control
    width: 480
    height: 270
    color: FluColors.Black
    clip: true

    property bool showControl: true

    MouseArea{
        anchors.fill: parent
        onClicked: {
            showControl = !showControl
        }
    }

    MediaPlayer {
        id: mediaplayer
        property bool autoSeek:true
        autoPlay: true
        source: control.source
        onError: {
            console.debug(error)
        }
        onPositionChanged: {
            if(autoSeek){
                slider.seek(mediaplayer.position*slider.maxValue/mediaplayer.duration)
            }
        }
        onStatusChanged: {
            if(status===6){
                slider.maxValue = mediaplayer.duration
            }
        }
    }

    onSourceChanged: {
        slider.seek(0)
    }

    VideoOutput {
        anchors.fill: parent
        source: mediaplayer
    }

    Item{
        height: 100
        y:showControl ? control.height - 110 : control.height
        anchors{
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
        }
        MouseArea{
            anchors.fill: parent
        }

        Behavior on y{
            NumberAnimation{
                duration: 150
            }
        }

        Rectangle{
            anchors.fill: parent
            color:FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,0.97) : Qt.rgba(237/255,237/255,237/255,0.97)
            radius: 5
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
                mediaplayer.seek(value*mediaplayer.duration/slider.maxValue)
                mediaplayer.autoSeek = true
            }
            onLineClickFunc:function(val){
                mediaplayer.seek(val*mediaplayer.duration/slider.maxValue)
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
            iconSource: mediaplayer.playbackState === Audio.PlayingState ?   FluentIcons.Pause  : FluentIcons.Play
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 10
            }
            onClicked: {
                if(mediaplayer.playbackState === Audio.PlayingState){
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

    function pause(){
        mediaplayer.pause()
    }

    function play(){
        mediaplayer.play()
    }

}

