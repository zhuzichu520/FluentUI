import QtQuick
import QtQuick.Controls
import FluentUI

Rectangle{
    property bool isDot: false
    property bool showZero: false
    property int count: 0
    property bool topRight: false
    id:control
    color:Qt.rgba(255/255,77/255,79/255,1)
    width: {
        if(isDot)
            return 10
        if(count<10){
            return 20
        }else if(count<100){
            return 30
        }
        return 40
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
    anchors{
        right: {
            if(parent && topRight)
                return parent.right
            return undefined
        }
        top: {
            if(parent && topRight)
                return parent.top
            return undefined
        }
        rightMargin: {
            if(parent && topRight){
                if(isDot){
                    return -2.5
                }
                return -(control.width/2)
            }
            return 0
        }
        topMargin: {
            if(parent && topRight){
                if(isDot){
                    return -2.5
                }
                return  -10
            }
            return 0
        }
    }
    visible: {
        if(showZero)
            return true
        return count!==0
    }
    FluText{
        anchors.centerIn: parent
        color: Qt.rgba(1,1,1,1)
        visible: !isDot
        text:{
            if(count<100)
                return count
            return "100+"
        }
    }
}
