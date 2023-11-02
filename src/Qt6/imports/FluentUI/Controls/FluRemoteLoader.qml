import QtQuick
import QtQuick.Controls
import FluentUI

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
    FluLoader{
        id:loader
        anchors.fill: parent
        asynchronous: true
        onStatusChanged: {
            if(status === Loader.Error){
                control.statusMode = FluStatusViewType.Error
            }else if(status === Loader.Loading){
                control.statusMode = FluStatusViewType.Loading
            }else{
                control.statusMode = FluStatusViewType.Success
            }
        }
    }
    function reload(){
        var timestamp = Date.now();
        loader.source = control.source+"?"+timestamp
    }
    function itemLodaer(){
        return loader
    }
}
