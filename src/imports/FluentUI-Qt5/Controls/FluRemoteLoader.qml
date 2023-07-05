import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

FluStatusView {
    property url source: ""
    property bool lazy: false
    color:"transparent"
    id:control
    onErrorClicked: {
        reload()
    }
    Component.onCompleted: {
        if(!lazy){
            loader.source = control.source
        }
    }
    Loader{
        id:loader
        anchors.fill: parent
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
