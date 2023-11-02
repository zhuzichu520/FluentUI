import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Button {
    display: Button.IconOnly
    property int iconSize: 20
    property int iconSource
    property bool disabled: false
    property int radius:4
    property string contentDescription: ""
    property color hoverColor: FluTheme.itemHoverColor
    property color pressedColor: FluTheme.itemPressColor
    property color normalColor: FluTheme.itemNormalColor
    property color disableColor: FluTheme.itemNormalColor
    property Component iconDelegate: com_icon
    property color color: {
        if(!enabled){
            return disableColor
        }
        if(pressed){
            return pressedColor
        }
        return hovered ? hoverColor : normalColor
    }
    property color iconColor: {
        if(FluTheme.dark){
            if(!enabled){
                return Qt.rgba(130/255,130/255,130/255,1)
            }
            return Qt.rgba(1,1,1,1)
        }else{
            if(!enabled){
                return Qt.rgba(161/255,161/255,161/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    id:control
    focusPolicy:Qt.TabFocus
    padding: 0
    verticalPadding: 8
    horizontalPadding: 8
    enabled: !disabled
    background: Rectangle{
        implicitWidth: 30
        implicitHeight: 30
        radius: control.radius
        color:control.color
        FluFocusRectangle{
            visible: control.activeFocus
        }
    }
    Component{
        id:com_icon
        FluIcon {
            id:text_icon
            font.pixelSize: iconSize
            iconSize: control.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            iconColor: control.iconColor
            iconSource: control.iconSource
        }
    }
    Component{
        id:com_row
        RowLayout{
            FluLoader{
                sourceComponent: iconDelegate
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            FluText{
                text:control.text
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.IconOnly
            }
        }
    }
    Component{
        id:com_column
        ColumnLayout{
            FluLoader{
                sourceComponent: iconDelegate
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            FluText{
                text:control.text
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.IconOnly
            }
        }
    }
    contentItem:Loader{
        sourceComponent: {
            if(display === Button.TextUnderIcon){
                return com_column
            }
            return com_row
        }
    }
    FluTooltip{
        id:tool_tip
        visible: {
            if(control.text === ""){
                return false
            }
            if(control.display !== Button.IconOnly){
                return false
            }
            return hovered
        }
        text:control.text
        delay: 1000
    }
}
