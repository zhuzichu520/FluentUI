import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

Rectangle {

    property color dividerColor: FluTheme.isDark ? Qt.rgba(77/255,77/255,77/255,1) : Qt.rgba(239/255,239/255,239/255,1)
    property color hoverColor: FluTheme.isDark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
    property color normalColor: FluTheme.isDark ? Qt.rgba(61/255,61/255,61/255,1) : Qt.rgba(254/255,254/255,254/255,1)
    property var window : Window.window

    id:root
    color: {
        if(mouse_area.containsMouse){
            return hoverColor
        }
        return normalColor
    }
    height: 30
    width: 120
    radius: 4
    border.width: 1
    border.color: dividerColor

    MouseArea{
        id:mouse_area
        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            popup.showPopup()
        }
    }

    FluText{
        id:text_date
        anchors{
            left: parent.left
            right: parent.right
            rightMargin: 30
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:"请选择日期"
    }

    FluIcon{
        iconSource: FluentIcons.Calendar
        iconSize: 14
        color: text_date.color
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 12
        }
    }


    Popup{
        id:popup
        height: container.height
        width: container.width
        modal: true
        dim:false
        background: FluCalendarView{
            id:container
            onDateClicked:
                (date)=>{
                    popup.close()
                    var year = date.getFullYear()
                    var month = date.getMonth()
                    var day =  date.getDate()
                    text_date.text = year+"-"+(month+1)+"-"+day
                }
        }
        contentItem: Item{}
        function showPopup() {
            var pos = root.mapToItem(null, 0, 0)
            if(window.height>pos.y+root.height+popup.height){
                popup.y = root.height
            } else if(pos.y>popup.height){
                popup.y = -popup.height
            } else {
                popup.y = window.height-(pos.y+popup.height)
            }
            popup.x = -(popup.width-root.width)/2
            popup.open()
        }
    }
}
