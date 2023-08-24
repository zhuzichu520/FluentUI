import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

ColumnLayout {
    default property alias buttons: control.data
    property int currentIndex : -1
    id:control
    onCurrentIndexChanged: {
        for(var i = 0;i<buttons.length;i++){
            buttons[i].checked = false
        }
        buttons[currentIndex].checked = true
    }
    Component.onCompleted: {
        for(var i = 0;i<buttons.length;i++){
            buttons[i].clickListener = function(){
                for(var i = 0;i<buttons.length;i++){
                    var button = buttons[i]
                    if(this === button){
                        currentIndex = i
                    }
                }
            }
        }
        currentIndex = 0
    }
}
