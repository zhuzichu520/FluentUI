import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluWindow {
    id:control
    property Component contentDelegate
    autoVisible: false
    autoCenter: false
    autoDestory: true
    fixSize: true
    Loader{
        anchors.fill: parent
        sourceComponent: {
            if(control.autoDestory){
                return control.visible ? control.contentDelegate : undefined
            }
            return control.contentDelegate
        }
    }
    closeListener: function(event){
        visible = false
        event.accepted = false
    }
    function showDialog(){
        var x = transientParent.x + (transientParent.width - width)/2
        var y = transientParent.y + (transientParent.height - height)/2
        control.stayTop = Qt.binding(function(){return transientParent.stayTop})
        setGeometry(x,y,width,height)
        visible = true
    }
}
