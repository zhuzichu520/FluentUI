import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import FluentUI 1.0

Rectangle {

    property url source
    property bool showControl: false
    property real volume: 30

    id:control
    width: 480
    height: 270
    color: FluColors.Black
    clip: true

    MouseArea{
        anchors.fill: parent
        preventStealing: true
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
                showControl = true
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
            color:FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,0.97) : Qt.rgba(237/255,237/255,237/255,0.97)
            radius: 5
        }

        FluSlider{
            id:slider
            size:parent.width-20
            y:20
            anchors.horizontalCenter: parent.horizontalCenter
            tipEnabled:false
            onPressed: {
                mediaplayer.autoSeek = false
                mediaplayer.pause()
            }
            value:0
            onReleased: {
                mediaplayer.autoSeek = true
                mediaplayer.play()
            }

            onValueChanged: {
                if(mediaplayer.autoSeek == false){
                    mediaplayer.seek(value*mediaplayer.duration/slider.maxValue)
                }
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


        Row{
            spacing: 10
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 10
            }
            FluIconButton{
                iconSize: 17
                iconSource:  FluentIcons.SkipBack10
                onClicked: {
                    mediaplayer.seek(Math.max(mediaplayer.position-10*1000,0))
                }
            }
            FluIconButton{
                iconSize: 15
                iconSource: mediaplayer.playbackState === Audio.PlayingState ?   FluentIcons.Pause  : FluentIcons.Play
                onClicked: {
                    if(mediaplayer.playbackState === Audio.PlayingState){
                        mediaplayer.pause()
                    }else{
                        mediaplayer.play()
                    }
                }
            }
            FluIconButton{
                iconSize: 17
                iconSource:  FluentIcons.SkipForward30
                onClicked: {
                    mediaplayer.seek(Math.min(mediaplayer.position+30*1000,mediaplayer.duration))
                }
            }
        }


        FluIconButton{
            id:btn_volume
            iconSize: 17
            iconSource:  mediaplayer.volume ?  FluentIcons.Volume :  FluentIcons.Mute
            anchors{
                left: parent.left
                leftMargin: 5
                bottom: parent.bottom
                bottomMargin: 10
            }
            onClicked: {
                mediaplayer.volume = !mediaplayer.volume
            }
        }

        FluSlider{
            id:slider_volume
            size: 80
            dotSize: 20
            value:30
            anchors{
                left:btn_volume.right
                verticalCenter: btn_volume.verticalCenter
                leftMargin: 10
            }
            onValueChanged:{
                mediaplayer.volume = value/100
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

