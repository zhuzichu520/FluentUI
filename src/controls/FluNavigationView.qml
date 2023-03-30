import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Item {

    property alias logo : image_logo.source
    property string title: ""
    property FluObject items
    property FluObject footerItems
    property int displayMode: width<=700 ? FluNavigationView.Minimal : FluNavigationView.Open
    property bool displaMinimalMenu : false
    property Component  autoSuggestBox

    id:root

    onDisplayModeChanged: {
        if(displayMode === FluNavigationView.Minimal){
            anim_navi.enabled = false
            displaMinimalMenu = false
            timer_anim_enable.restart()
        }
    }

    Timer{
        id:timer_anim_enable
        interval: 150
        onTriggered: {
            anim_navi.enabled = true
        }
    }

    enum DisplayMode {
        Minimal,
        Open,
        Auto
    }

    property var window : {
        if(Window.window == null)
            return null
        return Window.window
    }

    Component{
        id:com_panel_item_separatorr
        FluDivider{
            width: nav_list.width
            height: 1
        }
    }

    Component{
        id:com_panel_item_header
        Item{
            height: 30
            width: nav_list.width
            FluText{
                text:model.title
                fontStyle: FluText.BodyStrong
                anchors{
                    bottom: parent.bottom
                    left:parent.left
                    leftMargin: 10
                }
            }
        }
    }

    Component{
        id:com_panel_item
        Item{
            height: 38
            width: nav_list.width

            Rectangle{
                radius: 4
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 2
                    bottomMargin: 2
                    leftMargin: 6
                    rightMargin: 6
                }
                Rectangle{
                    width: 3
                    height: 18
                    radius: 1.5
                    color: FluTheme.primaryColor.dark
                    visible: nav_list.currentIndex === position && type===0
                    anchors{
                        verticalCenter: parent.verticalCenter
                    }
                }
                MouseArea{
                    id:item_mouse
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        if(type===0){
                            model.repTap()
                            if(nav_list.currentIndex !== position){
                                nav_list.currentIndex = position
                                model.tap()
                            }
                        }else{
                            model.tap()
                        }
                        displaMinimalMenu = false
                    }
                }
                color: {
                    if(FluTheme.dark){
                        if(item_mouse.containsMouse){
                            return Qt.rgba(1,1,1,0.03)
                        }
                        if((nav_list.currentIndex === position)&&type===0){
                            return Qt.rgba(1,1,1,0.06)
                        }
                        return Qt.rgba(0,0,0,0)
                    }else{
                        if(item_mouse.containsMouse){
                            return Qt.rgba(0,0,0,0.03)
                        }
                        if(nav_list.currentIndex === position&&type===0){
                            return Qt.rgba(0,0,0,0.06)
                        }
                        return Qt.rgba(0,0,0,0)
                    }
                }

                FluIcon{
                    id:item_icon
                    iconSource: {
                        if(model.icon){
                            return model.icon
                        }
                        return 0
                    }
                    width: 30
                    height: 30
                    iconSize: 15
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left:parent.left
                        leftMargin: 3
                    }
                }

                FluText{
                    id:item_title
                    text:model.title
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left:item_icon.right
                    }
                }
            }
        }
    }

    Item {
        id:nav_app_bar
        width: parent.width
        height: 50
        z:999
        RowLayout{
            height:parent.height
            spacing: 0
            FluIconButton{
                iconSource: FluentIcons.ChromeBack
                Layout.leftMargin: 5
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignVCenter
                disabled:  nav_swipe.depth === 1
                iconSize: 13
                onClicked: {
                    nav_swipe.pop()
                    nav_list.stackIndex.pop()
                    var index = nav_list.stackIndex[nav_list.stackIndex.length-1]
                    nav_list.enableStack = false
                    nav_list.currentIndex = index
                    nav_list.enableStack = true
                }
            }
            FluIconButton{
                id:btn_nav
                iconSource: FluentIcons.GlobalNavButton
                iconSize: 15
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                visible: displayMode === FluNavigationView.Minimal
                Layout.alignment: Qt.AlignVCenter
                onClicked: {
                    displaMinimalMenu = !displaMinimalMenu
                }
            }

            Image{
                id:image_logo
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20
                Layout.leftMargin: {
                    if(btn_nav.visible){
                        return 12
                    }
                    return 5
                }
                Layout.alignment: Qt.AlignVCenter
            }
            FluText{
                Layout.alignment: Qt.AlignVCenter
                text:root.title
                Layout.leftMargin: 12
                fontStyle: FluText.Body
            }
        }
    }

    Item{
        anchors{
            left: displayMode === FluNavigationView.Minimal ? parent.left : layout_list.right
            top: nav_app_bar.bottom
            right: parent.right
            bottom: parent.bottom
        }

        StackView{
            id:nav_swipe
            anchors.fill: parent
            clip: true
            popEnter : Transition{}
            popExit : Transition {
                NumberAnimation { properties: "y"; from: 0; to: nav_swipe.height; duration: 200 }
            }
            pushEnter: Transition {
                NumberAnimation { properties: "y"; from: nav_swipe.height; to: 0; duration: 200 }
            }
            pushExit : Transition{}
            replaceEnter : Transition{}
            replaceExit : Transition{}
        }
    }

    MouseArea{
        anchors.fill: parent
        enabled: (displayMode === FluNavigationView.Minimal && displaMinimalMenu)
        onClicked: {
            displaMinimalMenu = false
        }
    }

    Rectangle{
        id:layout_list
        width: 300
        border.color: FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,230/255,234/255,1)
        border.width:  displayMode === FluNavigationView.Minimal ? 1 : 0
        color: {
            if(displayMode === FluNavigationView.Minimal){
                return FluTheme.dark ? Qt.rgba(61/255,61/255,61/255,1) : Qt.rgba(243/255,243/255,243/255,1)
            }
            if(window && window.active){
                return FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(238/255,244/255,249/255,1)
            }
            return FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
        }
        anchors{
            top: parent.top
            bottom: parent.bottom
        }
        x: {
            if(displayMode !== FluNavigationView.Minimal)
                return 0
            return (displayMode === FluNavigationView.Minimal && displaMinimalMenu)  ? 0 : -width
        }
        Behavior on x{
            id:anim_navi
            NumberAnimation{
                duration: 150
            }
        }

        Behavior on color{
            ColorAnimation {
                duration: 300
            }
        }

        Item{
            id:layout_header
            width: layout_list.width
            y:nav_app_bar.height
            height: {
                if(loader_auto_suggest_box.item){
                    return loader_auto_suggest_box.item.height
                }
                return 0
            }
            Loader{
                id:loader_auto_suggest_box
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: autoSuggestBox
            }
        }

        ListView{
            id:nav_list
            property bool enableStack: true
            property var stackIndex: []
            clip: true
            anchors{
                top: layout_header.bottom
                topMargin: 6
                left: parent.left
                right: parent.right
                bottom: layout_footer.top
            }
            highlightMoveDuration: 150
            currentIndex: -1
            onCurrentIndexChanged: {
                if(enableStack){
                    stackIndex.push(currentIndex)
                }
            }
            ScrollBar.vertical: FluScrollBar {}

            model:{
                if(items){
                    return items.children
                }
            }
            delegate: Loader{
                property var model: modelData
                property var position: index
                property int type: 0
                sourceComponent: {
                    if(modelData instanceof FluPaneItem){
                        return com_panel_item
                    }
                    if(modelData instanceof FluPaneItemHeader){
                        return com_panel_item_header
                    }
                    if(modelData instanceof FluPaneItemSeparator){
                        return com_panel_item_separatorr
                    }
                }
            }
        }

        ListView{
            id:layout_footer
            width: layout_list.width
            height: childrenRect.height
            anchors.bottom: parent.bottom
            model: {
                if(footerItems){
                    return footerItems.children
                }
            }
            currentIndex: -1
            delegate: Loader{
                property var model: modelData
                property var position: index
                property int type: 1
                sourceComponent: {
                    if(modelData instanceof FluPaneItem){
                        return com_panel_item
                    }
                    if(modelData instanceof FluPaneItemHeader){
                        return com_panel_item_header
                    }
                    if(modelData instanceof FluPaneItemSeparator){
                        return com_panel_item_separatorr
                    }
                }
            }
        }
    }

    function push(url){
        nav_swipe.push(url)
    }

    function setCurrentIndex(index){
        nav_list.currentIndex = index
    }

    function getCurrentIndex(){
        return nav_list.currentIndex
    }

}
