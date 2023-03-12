import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0


Control {

    id:control
    property bool checked: false
    property string text: "RodioButton"
    signal clicked
    property bool disabled: false

    focusPolicy:Qt.TabFocus
    Keys.onEnterPressed:(visualFocus&&handleClick())
    Keys.onReturnPressed:(visualFocus&&handleClick())

    MouseArea {
        anchors.fill: parent
        onClicked: handleClick()
    }

    function handleClick(){
        if(disabled){
            return
        }

        control.clicked()
    }


    background: Item{
        FluFocusRectangle{
            visible: control.visualFocus
        }
    }

    contentItem: RowLayout{
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
                if(hovered){
                    if(checked){
                        return 5
                    }
                    return 1
                }
                if(hovered){
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
                    if(hovered){
                        return Qt.rgba(43/255,43/255,43/255,1)
                    }
                    return Qt.rgba(50/255,50/255,50/255,1)
                }else{
                    if(hovered){
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
            text: control.text
            Layout.alignment: Qt.AlignVCenter
        }

    }


}

