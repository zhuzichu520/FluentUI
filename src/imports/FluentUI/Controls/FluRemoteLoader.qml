import QtQuick
import QtQuick.Controls
import FluentUI

Item {
    id:control
    property url source: ""

    Loader{
        id:loader
        anchors.fill: parent
        source: control.source
        asynchronous: true
    }

    FluProgressRing{
        anchors.centerIn: parent
        visible: loader.status === Loader.Loading
    }

    function reload(){
        var timestamp = Date.now();
        loader.source = control.source+"?"+timestamp
    }

}
