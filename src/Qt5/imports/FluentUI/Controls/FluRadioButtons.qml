import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item{
    id:control
    default property list<QtObject> buttons
    property int currentIndex : -1
    property bool disabled: false
    property bool manuallyDisabled: false
    property int spacing: 8
    property int orientation: Qt.Vertical // Qt.Horizontal
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
        function refreshButtonStatus() {
            for(var i = 0;i<buttons.length;i++){
                if(!manuallyDisabled) buttons[i].enabled = !disabled
            }
        }
    }
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    onCurrentIndexChanged: {
        d.updateChecked()
    }
    onDisabledChanged: {
        d.refreshButtonStatus()
    }
    onManuallyDisabledChanged: {
        d.refreshButtonStatus()
    }
    
    GridLayout {
        data: control.buttons
        flow: orientation == Qt.Vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight 
        columns: orientation == Qt.Vertical ? 1 : -1
        columnSpacing: orientation == Qt.Vertical ? 0 : control.spacing
        rows: orientation == Qt.Vertical ? -1 : 1
        rowSpacing: orientation == Qt.Vertical ? control.spacing : 0
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
            d.refreshButtonStatus()
        }
    }
}
