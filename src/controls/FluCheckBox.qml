import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {

    id:root
    property bool checked: false
    property string text: "Check Box"
    property var checkClicked
    property bool hovered: mouse_area.containsMouse

    property bool disabled: false

    width: childrenRect.width
    height: childrenRect.height

    property color borderNormalColor: FluTheme.isDark ? Qt.rgba(160/255,160/255,160/255,1) : Qt.rgba(136/255,136/255,136/255,1)
    property color borderCheckedColor: FluTheme.isDark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color borderHoverColor: FluTheme.isDark ? Qt.rgba(167/255,167/255,167/255,1) : Qt.rgba(135/255,135/255,135/255,1)
    property color borderDisableColor: FluTheme.isDark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)

    property color normalColor: FluTheme.isDark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(247/255,247/255,247/255,1)
    property color checkedColor: FluTheme.isDark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color hoverColor: FluTheme.isDark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(244/255,244/255,244/255,1)
    property color checkedHoverColor: FluTheme.isDark ? Qt.darker(checkedColor,1.1) : Qt.lighter(checkedColor,1.1)

    property color checkedDisableColor: FluTheme.isDark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)

    property color disableColor: FluTheme.isDark ? Qt.rgba(50/255,50/255,50/255,1) : Qt.rgba(253/255,253/255,253/255,1)

    RowLayout{
        spacing: 4
        Rectangle{
            width: 22
            height: 22
            radius: 4
            border.color: {
                if(disabled){
                    return borderDisableColor
                }
                if(checked){
                    return borderCheckedColor
                }
                if(hovered){
                    return borderHoverColor
                }
                return borderNormalColor
            }
            border.width: 1
            color: {
                if(checked){
                    if(disabled){
                        return checkedDisableColor
                    }
                    if(hovered){
                        return checkedHoverColor
                    }
                    return checkedColor
                }
                if(hovered){
                    return hoverColor
                }
                return normalColor
            }

            FluIcon {
                anchors.centerIn: parent
                icon: FluentIcons.FA_check
                iconSize: 15
                visible: checked
                color: FluTheme.isDark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
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
        enabled: !disabled
        onClicked: {
            if(checkClicked){
                checkClicked()
                return
            }
            checked = !checked
        }
    }

}
