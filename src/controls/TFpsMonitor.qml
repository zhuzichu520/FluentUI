import QtQuick
import FluentUI

Item {

    readonly property alias fps: _private.fps;
    readonly property alias fpsAvg: _private.fpsAvg;
    property color color: "#C0C0C0"
    property Component contentItem: contentComponent;

    id: control
    width: contentItemLoader.width + 5;
    height: contentItemLoader.height + 5;



    Component{
        id:contentComponent
        FluText{
            color:control.color
            text: " Avg " + fpsAvg + " | " + fps + " Fps";
        }
    }

    FluObject{
        id:_private;
        property int frameCounter: 0
        property int frameCounterAvg: 0
        property int counter: 0
        property int fps: 0
        property int fpsAvg: 0
    }

    Rectangle {
        id: monitor
        radius: 3
        width: 6
        height: width
        opacity: 0;

        NumberAnimation on rotation {
            from:0
            to: 360
            duration: 800
            loops: Animation.Infinite
        }
        onRotationChanged: _private.frameCounter++;
    }

    Loader{
        id:contentItemLoader
        sourceComponent: contentItem
    }

    Timer {
        interval: 2000
        repeat: true
        running: visible
        onTriggered: {
            _private.frameCounterAvg += _private.frameCounter;
            _private.fps = _private.frameCounter/2;
            _private.counter++;
            _private.frameCounter = 0;
            if (_private.counter >= 3) {
                _private.fpsAvg = _private.frameCounterAvg/(2 * _private.counter)
                _private.frameCounterAvg = 0;
                _private.counter = 0;
            }
        }
    }
}
