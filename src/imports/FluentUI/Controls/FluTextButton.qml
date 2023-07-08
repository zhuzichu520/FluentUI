import QtQuick 2.12
import QtQuick.Controls 2.12
import FluentUI 1.0

Button {
    property bool disabled: false
    property string contentDescription: ""
    property color normalColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color hoverColor: FluTheme.dark ? Qt.darker(normalColor,1.15) : Qt.lighter(normalColor,1.15)
    property color pressedColor: FluTheme.dark ? Qt.darker(normalColor,1.3) : Qt.lighter(normalColor,1.3)
    property color disableColor: FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
    property color backgroundHoverColor: FluTheme.dark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
    property color backgroundPressedColor: FluTheme.dark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
    property color backgroundNormalColor: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
    property color backgroundDisableColor: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
    property bool textBold: true
    property color textColor: {
        if(!enabled){
            return disableColor
        }
        if(pressed){
            return pressedColor
        }
        return hovered ? hoverColor :normalColor
    }
    id: control
    horizontalPadding:6
    enabled: !disabled
    font:FluTextStyle.Body
    background: Rectangle{
        implicitWidth: 28
        implicitHeight: 28
        radius: 4
        color: {
            if(!enabled){
                return backgroundDisableColor
            }
            if(pressed){
                return backgroundPressedColor
            }
            if(hovered){
                return backgroundHoverColor
            }
            return backgroundNormalColor
        }
        FluFocusRectangle{
            visible: control.visualFocus
            radius:8
        }
    }
    focusPolicy:Qt.TabFocus
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    contentItem: FluText {
        id:btn_text
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.textColor
    }
}
