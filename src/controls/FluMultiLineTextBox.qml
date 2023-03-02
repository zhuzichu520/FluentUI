import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

TextArea{
    id:input
    width: 300
    color: FluApp.isDark ? "#FFFFFF" : "#1A1A1A"
    wrapMode: Text.WrapAnywhere
    selectByMouse: true
    selectionColor: {
        if(FluApp.isDark){
            return Qt.rgba(76/255,160/255,224/255,1)
        }else{
            return Qt.rgba(0/255,102/255,180/255,1)
        }
    }
    background: FluTextBoxBackground{
        inputItem: input
    }

}
