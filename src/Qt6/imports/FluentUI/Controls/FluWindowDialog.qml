import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

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
        control.visibility = Window.Hidden
        event.accepted = false
    }
    Connections{
        target: control.transientParent
        function onVisibilityChanged(){
            if(control.transientParent.visibility === Window.Hidden){
                control.visibility = Window.Hidden
            }
        }
    }
    function showDialog(){
        var x = transientParent.x + (transientParent.width - width)/2
        var y = transientParent.y + (transientParent.height - height)/2
        control.stayTop = Qt.binding(function(){return transientParent.stayTop})
        control.setGeometry(x,y,width,height)
        control.visibility = Window.Windowed
    }
}
