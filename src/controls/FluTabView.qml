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

    QtObject {
        id: d
        property int dragIndex: -1
        property bool dragBehavior: false
    }


    ListModel{
        id:tab_model
        ListElement{
            icon:""
            text:"Document0"
        }
        ListElement{
            icon:""
            text:"Document1"
        }
        ListElement{
            icon:""
            text:"Document2"
        }
    }

    ListView{
        id:tab_nav
        height: 34
        orientation: ListView.Horizontal
        width: parent.width
        model: tab_model
        move: Transition {
            NumberAnimation { properties: "x"; duration: 100; easing.type: Easing.OutCubic }
            NumberAnimation { properties: "y"; duration: 100; easing.type: Easing.OutCubic }
        }
        moveDisplaced: Transition {
            NumberAnimation { properties: "x"; duration: 300; easing.type: Easing.OutCubic}
            NumberAnimation { properties: "y"; duration: 100;  easing.type: Easing.OutCubic }
        }
        clip: true
        delegate:  Item{

            width: item_container.width
            height: item_container.height
            z: item_mouse_drag.pressed ? 1000 : 1

            Item{
                id:item_layout
                width: item_container.width
                height: item_container.height

                FluItem{
                    id:item_container

                    property real timestamp: new Date().getTime()

                    height: tab_nav.height
                    width: item_text.width+30
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

                        onPressed: {
                            item_container.timestamp = new Date().getTime();
                            d.dragBehavior = false;
                            var pos = tab_nav.mapFromItem(item_container, 0, 0)
                            d.dragIndex = model.index
                            item_container.parent = tab_nav
                            item_container.x = pos.x
                            item_container.y = pos.y
                        }

                        onReleased: {
                            var timeDiff = new Date().getTime() - item_container.timestamp
                            console.debug(timeDiff)
                            if (timeDiff < 150) {
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
                            var pos = tab_nav.mapFromItem(item_container, 0, 0);
                            var idx = tab_nav.indexAt(pos.x, pos.y);
                            if (idx > -1 && idx < tab_nav.count) {
                                tab_model.move(d.dragIndex, idx, 1)
                                d.dragIndex = idx;
                            }
                        }
                    }

                    Rectangle{
                        anchors.fill: parent
                        color: {
                            if(FluTheme.isDark){
                                if(item_mouse_hove.containsMouse){
                                    return Qt.rgba(1,1,1,0.03)
                                }
                                if(tab_nav.currentIndex === index){
                                    return Qt.rgba(1,1,1,0.06)
                                }
                                return Qt.rgba(0,0,0,0)
                            }else{
                                if(item_mouse_hove.containsMouse){
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
                        iconSource: FluentIcons.ChromeClose
                        iconSize: 10
                        width: 24
                        height: 24
                        anchors{
                            right: parent.right
                            rightMargin: 5
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
}
