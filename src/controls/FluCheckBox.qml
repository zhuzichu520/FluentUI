import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {

    id:root
    property bool checked: false
    property string text: "Check Box"
    width: childrenRect.width
    height: childrenRect.height

    RowLayout{
        spacing: 4
        Rectangle{
            width: 22
            height: 22
            radius: 4
            border.color: {
                if(FluApp.isDark){
                    if(checked){
                        return FluTheme.primaryColor.lighter
                    }
                    return Qt.rgba(160/255,160/255,160/255,1)
                }else{
                    if(checked){
                        if(mouse_area.containsMouse){
                            return Qt.rgba(25/255,117/255,187/255,1)
                        }
                        return FluTheme.primaryColor.dark
                    }
                    return Qt.rgba(136/255,136/255,136/255,1)
                }
            }
            border.width: 1
            color: {
                if(FluApp.isDark){
                    if(checked){
                        if(mouse_area.containsMouse){
                            return Qt.rgba(74/255,149/255,207/255,1)
                        }
                        return FluTheme.primaryColor.lighter
                    }
                    if(mouse_area.containsMouse){
                        return Qt.rgba(62/255,62/255,62/255,1)
                    }
                    return Qt.rgba(45/255,45/255,45/255,1)
                }else{
                    if(checked){
                        if(mouse_area.containsMouse){
                            return Qt.rgba(25/255,117/255,187/255,1)
                        }
                        return FluTheme.primaryColor.dark
                    }
                    if(mouse_area.containsMouse){
                        return Qt.rgba(244/255,244/255,244/255,1)
                    }
                    return  Qt.rgba(247/255,247/255,247/255,1)
                }
            }

            FluIcon {
                anchors.centerIn: parent
                icon: FluentIcons.FA_check
                iconSize: 15
                visible: checked
                color: FluApp.isDark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
            }
        }
        FluText{
            text:root.text
        }
    }


    MouseArea{
        id:mouse_area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            checked = !checked
        }
    }

}
