import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI

Page {
    default property alias content: d.children
    property alias currentIndex: nav_list.currentIndex
    property color textHighlightColor: FluTheme.dark ? FluColors.Grey10 : FluColors.Black
    property color textNormalColor: FluTheme.dark ? FluColors.Grey120 : FluColors.Grey120
    property color textHoverColor: FluTheme.dark ? FluColors.Grey80 : FluColors.Grey150
    property int textSpacing: 10
    property int headerSpacing: 20
    property int headerHeight: 40
    id:control
    width: 400
    height: 300
    font: FluTextStyle.Title
    implicitHeight: height
    implicitWidth: width
    FluObject{
        id:d
        property int tabY: control.headerHeight/2+control.font.pixelSize/2 + 3
    }
    background:Item{}
    header:ListView{
        id:nav_list
        implicitHeight: control.headerHeight
        implicitWidth: control.width
        model:d.children
        spacing: control.headerSpacing
        interactive: false
        orientation: ListView.Horizontal
        highlightMoveDuration: FluTheme.animationEnabled ? 167 : 0
        highlight: Item{
            clip: true
            Rectangle{
                height: 3
                radius: 1.5
                color: FluTheme.primaryColor
                width: nav_list.currentItem ? nav_list.currentItem.width : 0
                y:d.tabY
                Behavior on width {
                    enabled: FluTheme.animationEnabled
                    NumberAnimation{
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
        delegate: Button{
            id:item_button
            width: item_title.width
            height: nav_list.height
            focusPolicy:Qt.TabFocus
            background:Item{
                FluFocusRectangle{
                    anchors.margins: -4
                    visible: item_button.activeFocus
                    radius:4
                }
            }
            contentItem: Item{
                FluText {
                    id:item_title
                    text: modelData.title
                    anchors.centerIn: parent
                    font: control.font
                    color: {
                        if(nav_list.currentIndex === index) {
                            return textHighlightColor;
                        }
                        if (item_button.hovered) {
                            return textHoverColor;
                        } 
                        return textNormalColor;
                    }
                }
            }
            onClicked: {
                nav_list.currentIndex = index
            }
        }
    }
    Item{
        id:container
        anchors.fill: parent
        Repeater{
            model:d.children
            FluLoader{
                property var argument: modelData.argument
                anchors.fill: parent
                sourceComponent: modelData.contentItem
                visible: nav_list.currentIndex === index
            }
        }
    }
}
