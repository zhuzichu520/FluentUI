import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Button {
    property bool disabled: false
    property string contentDescription: ""
    property color disableColor: FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(233/255,233/255,233/255,1)
    property color checkColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color hoverColor: FluTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(240/255,240/255,240/255,1)
    property color normalColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(253/255,253/255,253/255,1)
    property color borderNormalColor: FluTheme.dark ? Qt.rgba(161/255,161/255,161/255,1) : Qt.rgba(141/255,141/255,141/255,1)
    property color borderCheckColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color borderDisableColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(200/255,200/255,200/255,1)
    property color dotNormalColor: FluTheme.dark ? Qt.rgba(208/255,208/255,208/255,1) : Qt.rgba(93/255,93/255,93/255,1)
    property color dotCheckColor: FluTheme.dark ? Qt.rgba(0/255,0/255,0/255,1) : Qt.rgba(255/255,255/255,255/255,1)
    property color dotDisableColor: FluTheme.dark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(150/255,150/255,150/255,1)
    property real textSpacing: 6
    property bool textRight: true
    property alias textColor: btn_text.textColor
    property var clickListener : function(){
        checked = !checked
    }
    id: control
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    enabled: !disabled
    focusPolicy:Qt.TabFocus
    onClicked: clickListener()
    padding: 0
    horizontalPadding: 0
    onCheckableChanged: {
        if(checkable){
            checkable = false
        }
    }
    background : Item{
        implicitHeight: 20
        implicitWidth: 40
    }
    contentItem: RowLayout{
        spacing: control.textSpacing
        layoutDirection:control.textRight ? Qt.LeftToRight : Qt.RightToLeft
        Rectangle {
            id:control_backgound
            width: background.width
            height: background.height
            radius: height / 2
            FluFocusRectangle{
                visible: control.activeFocus
                radius: parent.radius
            }
            color: {
                if(!enabled){
                    return disableColor
                }
                if(checked){
                    return checkColor
                }
                if(hovered){
                    return hoverColor
                }
                return normalColor
            }
            border.width: 1
            border.color: {
                if(!enabled){
                    return borderDisableColor
                }
                if(checked){
                    return borderCheckColor
                }
                return borderNormalColor
            }
            FluIcon {
                width:  parent.height
                x:checked ? control_backgound.width-width : 0
                scale: hovered&enabled ? 7/10 : 6/10
                iconSource: FluentIcons.FullCircleMask
                iconSize: 20
                color: {
                    if(!enabled){
                        return dotDisableColor
                    }
                    if(checked){
                        return dotCheckColor
                    }
                    return dotNormalColor
                }
                Behavior on x  {
                    enabled: FluTheme.enableAnimation
                    NumberAnimation {
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
        FluText{
            id:btn_text
            text: control.text
            Layout.alignment: Qt.AlignVCenter
            visible: text !== ""
        }
    }
}
