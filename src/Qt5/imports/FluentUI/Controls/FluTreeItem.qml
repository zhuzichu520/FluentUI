import QtQuick 2.15

QtObject {
    property string key
    property string title
    property var children: []
    property int depth: 0
    property bool isExpanded: true
    property var __parent
    property bool __expanded:{
        var p = __parent;
        while (p) {
            if(!p.isExpanded){
                return false
            }
            p = p.__parent;
        }
        return true
    }
    property int index: 0
}
