import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

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
