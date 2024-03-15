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
    autoDestory: false
    fixSize: true
    Loader{
        anchors.fill: parent
        sourceComponent: control.visible ? control.contentDelegate : undefined
    }
    function showDialog(){
        var x = transientParent.x + (transientParent.width - width)/2
        var y = transientParent.y + (transientParent.height - height)/2
        setGeometry(x,y,width,height)
        visible = true
    }
}
