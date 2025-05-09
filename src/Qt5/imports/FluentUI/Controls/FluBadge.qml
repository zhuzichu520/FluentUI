import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Rectangle{
    property bool isDot: false
    property bool showZero: false
    property var count: 0
    property int max: 99
    property string position: "" // topLeft, topRight, bottomLeft, bottomRight
    id:control
    color:Qt.rgba(255/255,77/255,79/255,1)
    width: {
        if(isDot)
            return 10
        return content_text.implicitWidth + 12
    }
    height: {
        if(isDot)
            return 10
        return 20
    }
    radius: {
        if(isDot)
            return 5
        return 10
    }
    border.width: 1
    border.color: Qt.rgba(1,1,1,1)
    anchors {
        left: {
            if(!parent){
                return undefined
            }
            return (position === "topLeft" || position === "bottomLeft") ? parent.left : undefined
        }
        right: {
            if(!parent){
                return undefined
            }
            return (position === "topRight" || position === "bottomRight") ? parent.right : undefined
        }
        top: {
            if(!parent){
                return undefined
            }
            return (position === "topLeft" || position === "topRight") ? parent.top : undefined
        }
        bottom: {
            if(!parent){
                return undefined
            }
            return (position === "bottomLeft" || position === "bottomRight") ? parent.bottom : undefined
        }
        leftMargin: {
            if(!parent){
                return 0
            }
            return (position === "topLeft" || position === "bottomLeft") ? (isDot ? -2.5 : -(width / 2)) : 0
        }
        rightMargin: {
            if(!parent){
                return 0
            }
            return (position === "topRight" || position === "bottomRight") ? (isDot ? -2.5 : -(width / 2)) : 0
        }
        topMargin: {
            if(!parent){
                return 0
            }
            return (position === "topLeft" || position === "topRight") ? (isDot ? -2.5 : -10) : 0
        }
        bottomMargin: {
            if(!parent){
                return 0
            }
            return (position === "bottomLeft" || position === "bottomRight") ? (isDot ? -2.5 : -10) : 0
        }
    }
    visible: {
        if(typeof(count) === "number"){
            return showZero ? true : count !== 0
        }
        return true
    }
    FluText{
        id: content_text
        anchors.centerIn: parent
        color: Qt.rgba(1,1,1,1)
        visible: !isDot
        text:{
            if(typeof(count) === "string"){
                return count
            }else if(typeof(count) === "number"){
                return count <= max ? count.toString() : "%1+".arg(max.toString())
            }
            return ""
        }
    }
}
