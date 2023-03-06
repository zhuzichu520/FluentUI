import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0


Item {

    id:root
    width: childrenRect.width
    height: childrenRect.height
    property bool checked: false
    property string text: "RodioButton"
    signal clicked
    property bool disabled: false

    RowLayout{
        Rectangle{
            id:rect_check
            width: 20
            height: 20
            radius: 10
            layer.samples: 4
            layer.enabled: true
            layer.smooth: true
            border.width: {
                if(checked&&disabled){
                    return 3
                }
                if(root_mouse.containsPress){
                    if(checked){
                        return 5
                    }
                    return 1
                }
                if(root_mouse.containsMouse){
                    if(checked){
                        return 3
                    }
                    return 1
                }
                return checked ? 5 : 1
            }
            Behavior on border.width {
                NumberAnimation{
                    duration: 100
                }
            }
            border.color: {
                if(disabled){
                    if(FluTheme.isDark){
                        return Qt.rgba(82/255,82/255,82/255,1)
                    }else{
                        return Qt.rgba(198/255,198/255,198/255,1)
                    }
                }
                if(checked){
                    if(FluTheme.isDark){
                        return FluTheme.primaryColor.lighter
                    }else{

                        return FluTheme.primaryColor.dark
                    }
                }else{
                    if(FluTheme.isDark){
                        return Qt.rgba(161/255,161/255,161/255,1)
                    }else{

                        return Qt.rgba(141/255,141/255,141/255,1)
                    }
                }
            }
            color:{
                if(disabled&&checked){
                    return Qt.rgba(159/255,159/255,159/255,1)
                }
                if(FluTheme.isDark){
                    if(root_mouse.containsMouse){
                        return Qt.rgba(43/255,43/255,43/255,1)
                    }
                    return Qt.rgba(50/255,50/255,50/255,1)
                }else{
                    if(root_mouse.containsMouse){
                        if(checked){
                            return Qt.rgba(1,1,1,1)
                        }
                        return Qt.rgba(222/255,222/255,222/255,1)
                    }
                    return Qt.rgba(1,1,1,1)
                }
            }
        }

        FluText{
            text: root.text
            Layout.alignment: Qt.AlignVCenter
        }

    }

    MouseArea{
        id:root_mouse
        hoverEnabled: true
        anchors.fill: parent
        enabled: !disabled
        onClicked: {
            root.clicked()
        }
    }

}

