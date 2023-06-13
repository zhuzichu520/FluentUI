import QtQuick
import QtQuick.Controls
import FluentUI

FluStatusView {
    property url source: ""
    color:"transparent"
    id:control
    onErrorClicked: {
        reload()
    }
    Loader{
        id:loader
        anchors.fill: parent
        source: control.source
        asynchronous: true
        onStatusChanged: {
            if(status === Loader.Error){
                control.statusMode = FluStatusView.Error
            }else if(status === Loader.Loading){
                control.statusMode = FluStatusView.Loading
            }else{
                control.statusMode = FluStatusView.Success
            }
        }
    }
    function reload(){
        var timestamp = Date.now();
        loader.source = control.source+"?"+timestamp
    }
}
