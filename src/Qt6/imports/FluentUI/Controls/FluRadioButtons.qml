import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import FluentUI

Item{
    id:control
    default property list<QtObject> buttons
    property int currentIndex : -1
    property int spacing: 8
    property int orientation: Qt.Vertical
    QtObject{
        id: d
        function updateChecked(){
            if(buttons.length === 0){
                return
            }
            for(var i = 0;i<buttons.length;i++){
                buttons[i].checked = false
            }
            if(currentIndex>=0 && currentIndex<buttons.length){
                buttons[currentIndex].checked = true
            }
        }
    }
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    onCurrentIndexChanged: {
        d.updateChecked()
    }
    Component{
        id:com_vertical
        ColumnLayout {
            data: control.buttons
            spacing: control.spacing
            Component.onCompleted: {
                for(var i = 0;i<control.buttons.length;i++){
                    control.buttons[i].clickListener = function(){
                        for(var i = 0;i<control.buttons.length;i++){
                            var button = control.buttons[i]
                            if(this === button){
                                control.currentIndex = i
                            }
                        }
                    }
                }
                d.updateChecked()
            }
        }
    }
    Component{
        id:com_horizontal
        RowLayout {
            data: control.buttons
            spacing: control.spacing
            Component.onCompleted: {
                for(var i = 0;i<control.buttons.length;i++){
                    control.buttons[i].clickListener = function(){
                        for(var i = 0;i<control.buttons.length;i++){
                            var button = control.buttons[i]
                            if(this === button){
                                control.currentIndex = i
                            }
                        }
                    }
                }
                d.updateChecked()
            }
        }
    }
    FluLoader{
        sourceComponent: control.orientation === Qt.Vertical ? com_vertical : com_horizontal
    }
}
