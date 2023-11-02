import QtQuick
import QtQuick.Controls
import FluentUI

Page {
    default property alias content: d.children
    property alias currentIndex: nav_list.currentIndex
    property color textNormalColor: FluTheme.dark ? FluColors.Grey120 : FluColors.Grey120
    property color textHoverColor: FluTheme.dark ? FluColors.Grey10 : FluColors.Black
    property int textSize: 28
    property bool textBold: true
    property int textSpacing: 10
    property int headerSpacing: 20
    property int headerHeight: 40
    id:control
    width: 400
    height: 300
    implicitHeight: height
    implicitWidth: width
    FluObject{
        id:d
        property int tabY: control.headerHeight/2+control.textSize/2 + 3
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
        highlightMoveDuration: FluTheme.enableAnimation ? 167 : 0
        highlight: Item{
            clip: true
            Rectangle{
                height: 3
                radius: 1.5
                color: FluTheme.primaryColor
                width: nav_list.currentItem ? nav_list.currentItem.width : 0
                y:d.tabY
                Behavior on width {
                    enabled: FluTheme.enableAnimation
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
                    font.pixelSize: control.textSize
                    font.bold: control.textBold
                    color: {
                        if(item_button.hovered || nav_list.currentIndex === index)
                            return textHoverColor
                        return textNormalColor
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
            Loader{
                property var argument: modelData.argument
                anchors.fill: parent
                sourceComponent: modelData.contentItem
                visible: nav_list.currentIndex === index
            }
        }
    }
}
