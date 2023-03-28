import QtQuick 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

Item {

    id:control
    anchors.fill: {
        if(parent)
            return parent
        return undefined
    }

    implicitHeight: height
    implicitWidth: width

    enum TabWidthBehavior {
        Equal,
        SizeToContent,
        Compact
    }

    enum CloseButtonVisibility{
        Nerver,
        Always,
        OnHover
    }

    property int tabWidthBehavior : FluTabView.Equal
    property int closeButtonVisibility : FluTabView.Always
    property int itemWidth: 146

    QtObject {
        id: d
        property int dragIndex: -1
        property bool dragBehavior: false
        property bool itemPress: false
    }

    ListModel{
        id:tab_model
    }

    ListView{
        id:tab_nav
        height: 34
        orientation: ListView.Horizontal
        width: parent.width
        interactive: false
        boundsBehavior: ListView.StopAtBounds
        model: tab_model
        move: Transition {
            NumberAnimation { properties: "x"; duration: 100; easing.type: Easing.OutCubic }
            NumberAnimation { properties: "y"; duration: 100; easing.type: Easing.OutCubic }
        }
        moveDisplaced: Transition {
            NumberAnimation { properties: "x"; duration: 300; easing.type: Easing.OutCubic}
            NumberAnimation { properties: "y"; duration: 100;  easing.type: Easing.OutCubic }
        }
        clip: false
        ScrollBar.horizontal: ScrollBar{
            id: scroll_nav
            policy: ScrollBar.AlwaysOff
        }
        delegate:  Item{

            width: itemWidth
            height: item_container.height
            z: item_mouse_drag.pressed ? 1000 : 1

            Item{
                id:item_layout
                width: itemWidth
                height: item_container.height

                FluItem{
                    id:item_container

                    property real timestamp: new Date().getTime()

                    height: tab_nav.height
                    width: itemWidth
                    radius: [5,5,0,0]
                    Behavior on x { enabled: d.dragBehavior; NumberAnimation { duration: 200 } }
                    Behavior on y { enabled: d.dragBehavior; NumberAnimation { duration: 200 } }

                    MouseArea{
                        id:item_mouse_hove
                        anchors.fill: parent
                        hoverEnabled: true
                    }

                    MouseArea{
                        id:item_mouse_drag
                        anchors.fill: parent
                        drag.target: item_container
                        drag.axis: Drag.XAxis

                        onWheel: {
                            if (wheel.angleDelta.y > 0) scroll_nav.decrease()
                            else scroll_nav.increase()
                        }

                        onPressed: {
                            d.itemPress = true
                            item_container.timestamp = new Date().getTime();
                            d.dragBehavior = false;
                            var pos = tab_nav.mapFromItem(item_container, 0, 0)
                            d.dragIndex = model.index
                            item_container.parent = tab_nav
                            item_container.x = pos.x
                            item_container.y = pos.y
                        }

                        onReleased: {
                            d.itemPress = false
                            timer.stop()
                            var timeDiff = new Date().getTime() - item_container.timestamp
                            if (timeDiff < 300) {
                                tab_nav.currentIndex = index
                            }
                            d.dragIndex = -1;
                            var pos = tab_nav.mapToItem(item_layout, item_container.x, item_container.y)
                            item_container.parent = item_layout;
                            item_container.x = pos.x;
                            item_container.y = pos.y;
                            d.dragBehavior = true;
                            item_container.x = 0;
                            item_container.y = 0;
                        }

                        onPositionChanged: {
                            var pos = tab_nav.mapFromItem(item_container, 0, 0)
                            updatePosition(pos)
                            if(pos.x<0){
                                timer.isIncrease = false
                                timer.restart()
                            }else if(pos.x>tab_nav.width-itemWidth){
                                timer.isIncrease = true
                                timer.restart()
                            }else{
                                timer.stop()
                            }
                        }
                        Timer{
                            id:timer
                            property bool isIncrease: true
                            interval: 10
                            repeat: true
                            onTriggered: {
                                if(isIncrease){
                                    if(tab_nav.contentX>=tab_nav.contentWidth-tab_nav.width){
                                        return
                                    }
                                    tab_nav.contentX = tab_nav.contentX+2
                                }else{
                                    if(tab_nav.contentX<=0){
                                        return
                                    }
                                    tab_nav.contentX = tab_nav.contentX-2
                                }
                                item_mouse_drag.updatePosition(tab_nav.mapFromItem(item_container, 0, 0))
                            }
                        }
                        function updatePosition(pos){
                            var idx = tab_nav.indexAt(pos.x+tab_nav.contentX, pos.y)
                            var firstIdx = tab_nav.indexAt(tab_nav.contentX+1, pos.y)
                            var lastIdx = tab_nav.indexAt(tab_nav.width+tab_nav.contentX-1, pos.y)
                            if (idx >= firstIdx && idx <= lastIdx && d.dragIndex !== idx) {
                                tab_model.move(d.dragIndex, idx, 1)
                                d.dragIndex = idx;
                            }
                        }
                    }

                    Rectangle{
                        anchors.fill: parent
                        color: {
                            if(FluTheme.isDark){
                                if(item_mouse_hove.containsMouse || item_btn_close.hovered){
                                    return Qt.rgba(1,1,1,0.03)
                                }
                                if(tab_nav.currentIndex === index){
                                    return Qt.rgba(1,1,1,0.06)
                                }
                                return Qt.rgba(0,0,0,0)
                            }else{
                                if(item_mouse_hove.containsMouse || item_btn_close.hovered){
                                    return Qt.rgba(0,0,0,0.03)
                                }
                                if(tab_nav.currentIndex === index){
                                    return Qt.rgba(0,0,0,0.06)
                                }
                                return Qt.rgba(0,0,0,0)
                            }
                        }
                    }

                    FluText{
                        id:item_text
                        anchors.centerIn: parent
                        text: model.text
                        rightPadding: 24
                    }

                    FluIconButton{
                        id:item_btn_close
                        iconSource: FluentIcons.ChromeClose
                        iconSize: 10
                        width: 24
                        height: 24
                        anchors{
                            right: parent.right
                            rightMargin: 5
                            verticalCenter: parent.verticalCenter
                        }
                        onClicked: {
                            tab_model.remove(index)
                        }
                    }
                }
            }
        }
    }


    Item{
        id:container
        anchors{
            top: tab_nav.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Repeater{
            model:tab_model
            Loader{
                property var argument: model.argument
                anchors.fill: parent
                sourceComponent: model.page
                visible: tab_nav.currentIndex === index
            }
        }
    }


    function createTab(icon,text,page,argument={}){
        return {icon:icon,text:text,page:page,argument:argument}
    }

    function appendTab(icon,text,page,argument){
        tab_model.append(createTab(icon,text,page,argument))
    }

    function setTabList(list){
        tab_model.clear()
        tab_model.append(list)
    }

}
