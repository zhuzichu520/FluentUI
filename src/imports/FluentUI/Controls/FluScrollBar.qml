import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import FluentUI 1.0

T.ScrollBar {
    id: control

    property color color : FluTheme.dark ? Qt.rgba(159/255,159/255,159/255,1) : Qt.rgba(138/255,138/255,138/255,1)
    property color pressedColor: FluTheme.dark ? Qt.darker(color,1.2) : Qt.lighter(color,1.2)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 2
    visible: control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: Math.max(orientation === Qt.Horizontal ? height / width : width / height,0.3)
    contentItem: Item {
        property bool collapsed: (control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0))
        implicitWidth: control.interactive ? 6 : 2
        implicitHeight: control.interactive ? 6 : 2

        Rectangle{
            id:rect_bar
            width:  vertical ? 2 : parent.width
            height: horizontal  ? 2 : parent.height
            color:{
                if(control.pressed){
                    return control.pressedColor
                }
                return control .color
            }
            anchors{
                right: vertical ? parent.right : undefined
                bottom: horizontal ? parent.bottom : undefined
            }
            radius: width / 2
            visible: control.size < 1.0
        }
        states: [
            State{
                name:"show"
                when: contentItem.collapsed
                PropertyChanges {
                    target: rect_bar
                    width:  vertical ? 6 : parent.width
                    height: horizontal  ? 6 : parent.height
                }
            }
            ,State{
                name:"hide"
                when: !contentItem.collapsed
                PropertyChanges {
                    target: rect_bar
                    width:  vertical ? 2 : parent.width
                    height: horizontal  ? 2 : parent.height
                }
            }
        ]
        transitions:[
            Transition {
                to: "hide"
                SequentialAnimation {
                    PauseAnimation { duration: 450 }
                    NumberAnimation {
                        target: rect_bar
                        properties: vertical ? "width"  : "height"
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
            ,Transition {
                to: "show"
                NumberAnimation {
                    target: rect_bar
                    properties: vertical ? "width"  : "height"
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
        ]
    }
}
